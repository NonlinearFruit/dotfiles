WEZTERM = require('wezterm')
ACTION = WEZTERM.action
OPACITY_EVENT = 'toggle-opacity'

WEZTERM.on(OPACITY_EVENT, function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 0 then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = (overrides.window_background_opacity or 1) - 0.25
  end
  window:set_config_overrides(overrides)
end)

local function getDefaultConfig()
  return WEZTERM.config_builder()
end

local function disableUnwantedFeatures(config)
  config.hide_tab_bar_if_only_one_tab = true
  config.window_close_confirmation = "NeverPrompt"
  config.window_padding = { top = 0, bottom = 0, left = 0, right = 0 }
  config.enable_scroll_bar = false
  config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
  return config
end

local function bindKeys(config)
  config.keys = {
    { key = "F11", action = ACTION.ToggleFullScreen },
    { key = "c", mods = "CTRL|SHIFT", action = ACTION.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = ACTION.PasteFrom("Clipboard") },
    { key = "p", mods = "CTRL|SHIFT", action = ACTION.ActivateCommandPalette },
    { key = 'o', mods = 'CTRL|SHIFT', action = ACTION.EmitEvent(OPACITY_EVENT)},
  }
  return config
end

local function configureDisplay(config)
  config.color_scheme = 'Black Metal (base16)'
  config.font = WEZTERM.font('JetBrainsMono Nerd Font Mono')
  config.font_size = 14
  return config
end

return configureDisplay(
  bindKeys(
  disableUnwantedFeatures(
  getDefaultConfig())))

