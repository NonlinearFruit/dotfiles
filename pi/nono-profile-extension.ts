// Show $NONO_PROFILE in status bar when it is available
export default function (pi) {
  const profile = process.env.NONO_PROFILE
  if (!profile) return
  pi.on("session_start", async (_, ctx) => {
    appendNonoProfile(ctx, profile)
  });
}

function appendNonoProfile(ctx, profile) {
  const theme = ctx.ui.theme
  const label = theme.fg("dim", "nono:")
  const value = theme.fg(THEMES[profile] ?? "error", ` ${profile}`)
  ctx.ui.setStatus("nono-profile", label + value)
}

const THEMES = {
  "air-gapped": "accent",
  "cwd-read": "success",
  "projects-read": "success",
  "cwd": "warning",
  "projects": "error"
}

