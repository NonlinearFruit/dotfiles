export default function goOnExtension(pi) {
  pi.registerCommand("go-on", {
    description: "Tell the LLM to keep going",
    handler: async (_, ctx) =>
      ctx.isIdle()
      ? pi.sendMessage(
          {
            customType: "go-on",
            content: "Do go on",
            display: true,
          },
          { triggerTurn: true }
        )
      : ctx.ui.notifiy()
  });
}
