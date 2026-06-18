import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (!isToolCallEventType("edit", event)) return;

    const error = validateEdits(event.input.edits);
    if (error) {
      ctx.ui.notify(error, "error");
      return { block: true, reason: "Invalid edit parameters" };
    }
  });
}

function validateEdits(edits: unknown): string | null {
  if (!Array.isArray(edits)) {
    return "❌ edits must be an array";
  }

  if (edits.length === 0) return null;

  for (let i = 0; i < edits.length; i++) {
    const item = edits[i];

    if (!isValidEditItem(item)) {
      return `❌ Edit ${i}: must have oldText (string) and newText (string)`;
    }

    const jsonError = trySerializeEdit(item as EditItem);
    if (jsonError) {
      return `❌ Edit ${i} has JSON serialization error:\n  ${jsonError}\n\n` +
             `Common cause: Unescaped quotes in oldText or newText.\n` +
             `Tip: Break into smaller edits or escape special characters.`;
    }
  }

  const overlapError = findOverlap(edits as EditItem[]);
  if (overlapError) {
    return `❌ ${overlapError}\n\n` +
           `Solution: Ensure each oldText is unique and non-overlapping.`;
  }

  return null;
}

function isValidEditItem(item: unknown): boolean {
  if (typeof item !== "object" || item === null) return false;
  const e = item as Record<string, unknown>;
  return typeof e.oldText === "string" && typeof e.newText === "string";
}

function trySerializeEdit(edit: EditItem): string | null {
  try {
    JSON.stringify({ edits: [edit] });
    return null;
  } catch (err) {
    return (err as Error).message;
  }
}

function findOverlap(edits: EditItem[]): string | null {
  for (let i = 0; i < edits.length; i++) {
    for (let j = i + 1; j < edits.length; j++) {
      const a = edits[i].oldText;
      const b = edits[j].oldText;

      if (a === b) {
        return `Edits ${i} and ${j}: identical oldText`;
      }

      if (a.includes(b) || b.includes(a)) {
        return `Edits ${i} and ${j}: overlapping oldText (one contains the other)`;
      }
    }
  }

  return null;
}

interface EditItem {
  oldText: string;
  newText: string;
}
