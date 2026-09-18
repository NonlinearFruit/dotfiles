import { writeFile, readdir } from "node:fs/promises";
import { join, isAbsolute, dirname, basename } from "node:path";
import { homedir } from "node:os";

export default function (pi) {
  const getFileCompletions = async (prefix) => {
    try {
      // Resolve the directory and file prefix
      let dir = "";
      let filePrefix = prefix;

      if (prefix.includes("/")) {
        dir = dirname(prefix);
        filePrefix = basename(prefix);
      } else if (prefix.startsWith("~")) {
        const home = homedir();
        const rest = prefix.slice(1);
        if (rest.includes("/")) {
          dir = join(home, dirname(rest));
          filePrefix = basename(rest);
        } else {
          dir = home;
          filePrefix = rest;
        }
      } else {
        dir = ".";
      }

      // Read directory contents
      const entries = await readdir(dir, { withFileTypes: true });
      const completions = [];

      for (const entry of entries) {
        if (entry.name.startsWith(filePrefix)) {
          const fullPath = join(dir, entry.name);
          let displayPath = fullPath;
          if (prefix.startsWith("~")) {
            displayPath = "~" + fullPath.slice(homedir().length);
          }

          completions.push({
            value: displayPath + (entry.isDirectory() ? "/" : ""),
            label: entry.name + (entry.isDirectory() ? "/" : ""),
          });
        }
      }

      return completions.length > 0 ? completions : null;
    } catch {
      return null;
    }
  };

  pi.registerCommand("save-last", {
    description: "Export the most recent AI response to a txt file",
    getArgumentCompletions: (prefix) => getFileCompletions(prefix),
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

      let filepath;
      if (isAbsolute(filename)) {
        filepath = filename;
      } else if (filename.startsWith("~")) {
        filepath = join(homedir(), filename.slice(1));
      } else {
        filepath = join(ctx.cwd, filename);
      }

      await writeFile(filepath, lastAssistantText, "utf8");
      ctx.ui.notify(`Exported to ${filename}`, "success");
    },
  });
}
