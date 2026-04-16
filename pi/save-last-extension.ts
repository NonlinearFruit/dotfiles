import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { writeFile } from "node:fs/promises";
import { join } from "node:path";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("save-last", {
    description: "Export the most recent AI response to a txt file",
    handler: async (args, ctx) => {
      ctx.ui.notify(`Export started`, "success");
      const entries = ctx.sessionManager.getBranch();

      let lastAssistantText = null;
      for (let i = entries.length - 1; i >= 0; i--) {
        const entry = entries[i];
        if (entry.type === "message" && entry.message.role !== "user") {
          const textParts = entry.message.content
            .filter(block => block.type === "text")
            .map(block => block.text);
          if (textParts.length > 0) {
            lastAssistantText = textParts.join("\n");
            break;
          }
        }
      }

      if (!lastAssistantText) {
        ctx.ui.notify("No AI response found in this session.", "warn");
        return;
      }

      const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
      const filename = args.trim() || `ai-response-${timestamp}.txt`;
      const filepath = join(ctx.cwd, filename);

      await writeFile(filepath, lastAssistantText, "utf8");
      ctx.ui.notify(`Exported to ${filename}`, "success");
    },
  });
}
