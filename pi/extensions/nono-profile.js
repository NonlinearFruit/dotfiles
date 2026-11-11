// Show $NONO_PROFILE in status bar when it is available
export default function (pi) {
  const profile = process.env.NONO_PROFILE || "off"
  pi.on("session_start", async (_, ctx) => {
    appendNonoProfile(ctx, profile)
    if (profile === "off") pi.setActiveTools([])
  });
  pi.on("tool_call", async (event) => {
    if (profile === "off")
      return { block: true, reason: `${event.toolName} blocked: nono is off` }
  });
}

function appendNonoProfile(ctx, profile) {
  const theme = ctx.ui.theme
  const label = theme.fg("dim", "nono:")
  const value = theme.fg(THEMES[profile] ?? "error", ` ${profile}`)
  const tools = profile === "off" ? theme.fg("dim", " / tools:") + theme.fg("error", " disabled") : ""
  ctx.ui.setStatus("nono-profile", label + value + tools)
}

const THEMES = {
  "air-gapped": "accent",
  "cwd-read": "success",
  "projects-read": "success",
  "cwd": "warning",
  "projects": "error",
  "off": "error"
}
