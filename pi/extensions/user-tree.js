import { copyToClipboard, TreeSelectorComponent } from "@earendil-works/pi-coding-agent";

export default function (pi) {
  pi.registerCommand("user-tree", {
    description: "Navigate session tree (user messages only)",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify("/user-tree requires interactive mode", "error");
        return;
      }

      const tree = ctx.sessionManager.getTree();
      if (tree.length === 0) {
        ctx.ui.notify("No entries in session", "info");
        return;
      }

      const entryId = await ctx.ui.custom((tui, _theme, _kb, done) => {
        const selector = new TreeSelectorComponent(
          tree,
          ctx.sessionManager.getLeafId(),
          tui.terminal.rows,
          done,
          () => done(undefined),
          (id, label) => pi.setLabel(id, label),
          undefined,
          "user-only",
        );
        selector.onCopy = async (text) => {
          if (!text) {
            ctx.ui.notify("Selected entry has no text to copy", "error");
            return;
          }
          try {
            await copyToClipboard(text);
            ctx.ui.notify("Copied selected message to clipboard", "info");
          } catch (error) {
            ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
          }
        };
        return selector;
      });

      if (!entryId) return;
      if (entryId === ctx.sessionManager.getLeafId()) {
        ctx.ui.notify("Already at this point", "info");
        return;
      }

      if (!ctx.isIdle()) {
        ctx.abort();
        await ctx.waitForIdle();
      }

      try {
        const result = await ctx.navigateTree(entryId, { summarize: false });
        if (result.cancelled) ctx.ui.notify("Navigation cancelled", "info");
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
      }
    },
  });
}
