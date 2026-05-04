/**
 * Answer Extension
 *
 * Parses the previous AI response for questions, asks them interactively
 * to the user one at a time, then feeds the Q&A pairs back to the AI.
 *
 * Usage:
 *   /answer   - extract questions from the last assistant message and answer them
 */

import type { ExtensionAPI, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";

function getLastAssistantText(ctx: ExtensionCommandContext): string | null {
  const branch = ctx.sessionManager.getBranch();
  for (let i = branch.length - 1; i >= 0; i--) {
    const entry = branch[i];
    if (entry.type !== "message") continue;
    const msg = entry.message;
    if (!("role" in msg) || msg.role !== "assistant") continue;
    const textParts = msg.content
      .filter((c): c is { type: "text"; text: string } => c.type === "text")
      .map((c) => c.text);
    if (textParts.length > 0) return textParts.join("\n");
  }
  return null;
}

/**
 * Extract questions from text.
 *
 * Strategy: find any sentence ending with "?". Works across list items,
 * numbered items, inline prose. Strips leading bullet/number markers and
 * common markdown emphasis so the prompt reads cleanly.
 */
function extractQuestions(text: string): string[] {
  const questions: string[] = [];
  const seen = new Set<string>();

  // Split into "sentences" by terminal punctuation while keeping the '?' tokens.
  // Regex captures text up to and including ? . or ! (or end-of-string).
  const sentenceRe = /[^.!?\n]*\?/g;
  let match: RegExpExecArray | null;
  while ((match = sentenceRe.exec(text)) !== null) {
    let q = match[0].trim();
    if (!q.endsWith("?")) continue;

    // Strip leading list/number markers: "- ", "* ", "1. ", "1) ", "**1.** "
    q = q.replace(/^[-*+•]\s+/, "");
    q = q.replace(/^\*+\s*/, "");
    q = q.replace(/^\d+[.)]\s+/, "");
    q = q.replace(/^\*\*[^*]+\*\*\s*[:\-]?\s*/, "");

    // Strip surrounding markdown emphasis
    q = q.replace(/\*\*/g, "").replace(/__/g, "").replace(/`/g, "");

    // Collapse whitespace
    q = q.replace(/\s+/g, " ").trim();

    if (q.length < 3) continue;
    if (seen.has(q)) continue;
    seen.add(q);
    questions.push(q);
  }

  return questions;
}

function formatQA(pairs: Array<{ question: string; answer: string }>): string {
  const lines: string[] = [
    "Here are my answers to the questions you asked:",
    "",
  ];
  pairs.forEach((p, i) => {
    lines.push(`${i + 1}. ${p.question}`);
    lines.push(`   ${p.answer}`);
    lines.push("");
  });
  lines.push("Please continue based on these answers.");
  return lines.join("\n");
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand("answer", {
    description: "Extract questions from the last AI response and answer them interactively",
    handler: async (_args, ctx) => {
      if (!ctx.hasUI) {
        ctx.ui.notify("/answer requires interactive mode", "error");
        return;
      }

      const lastText = getLastAssistantText(ctx);
      if (!lastText) {
        ctx.ui.notify("No previous assistant message found", "error");
        return;
      }

      const questions = extractQuestions(lastText);
      if (questions.length === 0) {
        ctx.ui.notify("No questions found in the last AI response", "warning");
        return;
      }

      ctx.ui.notify(`Found ${questions.length} question${questions.length === 1 ? "" : "s"}`, "info");

      const pairs: Array<{ question: string; answer: string }> = [];
      for (let i = 0; i < questions.length; i++) {
        const q = questions[i];
        const title = `Question ${i + 1}/${questions.length}: ${q}`;
        const answer = await ctx.ui.input(title, "Type your answer...");

        if (answer === null || answer === undefined) {
          ctx.ui.notify("Cancelled", "info");
          return;
        }

        pairs.push({ question: q, answer: answer.trim() || "(no answer)" });
      }

      const reply = formatQA(pairs);

      if (ctx.isIdle()) {
        pi.sendUserMessage(reply);
      } else {
        pi.sendUserMessage(reply, { deliverAs: "followUp" });
      }

      ctx.ui.notify("Answers sent to AI", "info");
    },
  });
}
