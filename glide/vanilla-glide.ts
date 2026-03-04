// Glide the way it should be out of the box
glide.o.hint_size = "18px"

// Make it obvious what mode is on
glide.autocmds.create("ModeChanged", "*", ({ new_mode }) => {
  const mode_colors: Record<keyof GlideModes, string> = {
    "command": "#689F38", // Green
    "hint": "#00796B", // Teal
    "ignore": "#FF5252", // Red
    "insert": "#FBC02D", // Yellow
    "normal": "#9E9E9E", // Gray
    "op-pending": "#FF8F00", // Orange
    "visual": "#7B1FA2", // Purple
  }
  browser.theme.update({ colors: { frame: mode_colors[new_mode] } });
});

// Always normal mode when switching tabs
browser.tabs.onActivated.addListener(async (activeInfo) => {
  await new Promise((resolve) => setTimeout(resolve, 100));
  await glide.excmds.execute("mode_change normal");
});

// Vanilla binding but with helpful description
glide.keymaps.set(["normal", "insert"], "<C-,>", "blur", { description: "Go to normal mode without focus on a specific element" })

// Same functionality, better binding
glide.keymaps.del("normal", "<leader>f")
glide.keymaps.set("normal", "gf", "hint --location=browser-ui", { description: "[g]lobal [f]ind for browser ui clickables" })
