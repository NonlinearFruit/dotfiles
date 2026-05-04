const DESCRIPTION = {
  off: "No reasoning (fastest)",
  minimal: "Minimal internal reasoning",
  low: "Low-effort reasoning",
  medium: "Balanced reasoning and speed",
  high: "Deep reasoning",
  xhigh: "Maximum reasoning (slowest)",
};
const LEVELS = Object.keys(DESCRIPTION)

export default function thinkingExtension(pi) {
  pi.registerCommand("thinking", {
    description: "Set thinking level",
    getArgumentCompletions: (prefix) =>
      LEVELS
        .filter(l => l.startsWith(prefix))
        .map(l => ({ value: l, label: `${l} - ${DESCRIPTION[l]}` })),
    handler: (args, ctx) => handleThinking(args, ctx, pi),
  });
}

async function handleThinking(args, ctx, pi) {
  const arg = args.trim();
  const level = LEVELS.includes(arg)
    ? arg
    : await ctx.ui.select("Thinking level:", LEVELS);

  if (level && level !== pi.getThinkingLevel()) {
    pi.setThinkingLevel(level);
    ctx.ui.notify(`${level} (${DESCRIPTION[level]})`, "success");
  }
}
