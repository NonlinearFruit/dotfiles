local wezterm = require('wezterm')
local action = wezterm.action

local config = wezterm.config_builder()
config.color_scheme = 'Black Metal (base16)'
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_padding = { top = 0, bottom = 0, left = 0, right = 0 }
config.keys = {
  { key = "F11", action = action.ToggleFullScreen },
  { key = "c", mods = "CTRL|SHIFT", action = action.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = action.PasteFrom("Clipboard") },
  { key = "p", mods = "CTRL|SHIFT", action = action.ActivateCommandPalette },
}
config.font = wezterm.font('JetBrainsMono Nerd Font Mono')
config.font_size = 14
config.enable_scroll_bar = false
return config
