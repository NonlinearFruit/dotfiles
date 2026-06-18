export default function nopeExtension(pi) {
  pi.registerCommand("nope", {
    description: "Nope out of the current LLM turn",
    handler: (_, ctx) =>
      ctx.isIdle()
      ? ctx.ui.notify("Uno Reverse: your /nope was noped", "info")
      : ctx.abort(),
  });
}
