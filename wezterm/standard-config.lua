WEZTERM = require('wezterm')
ACTION = WEZTERM.action
OPACITY_EVENT = 'toggle-opacity'
SCHEMES = require('colorschemes').dark

WEZTERM.on(OPACITY_EVENT, function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if overrides.window_background_opacity == 0 then
    overrides.window_background_opacity = nil
  else
    overrides.window_background_opacity = (overrides.window_background_opacity or 1) - 0.25
  end
  window:set_config_overrides(overrides)
end)

WEZTERM.on("new-scheme", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local currentScheme = overrides.color_scheme or SCHEMES[1]
  local function indexOf(array, value)
      for i, v in ipairs(array) do
          if v == value then
              return i
          end
      end
      return nil
  end
  local maxIndex = #SCHEMES
  local currentIndex = indexOf(SCHEMES, currentScheme)
  local nextIndex = currentIndex + 1
  if nextIndex > maxIndex then
    nextIndex = 1
  end
  local newScheme = SCHEMES[nextIndex]
  WEZTERM.log_info(currentIndex..' == '..currentScheme..' -> '..nextIndex..' == '..newScheme)
  overrides.color_scheme = newScheme
  window:set_config_overrides(overrides)
  window:toast_notification('dotfiles', 'Color Scheme #'..nextIndex..': '..newScheme, nil, 500)
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
    { key = 's', mods = 'CTRL|SHIFT', action = ACTION.EmitEvent("new-scheme")},
    { key = 'k', mods = 'ALT', action = WEZTERM.action_callback(function(window, pane) pane:send_text 'pd_day.sh' end) },
  }
  return config
end

local function configureDisplay(config)
  config.color_scheme = SCHEMES[0]
  config.font_size = 14
  return config
end

local function configureIfWindows(config)
  local function isWindows()
    return  string.find(WEZTERM.target_triple, 'windows')
  end
  if isWindows() then
    config.default_prog = { "wsl.exe", "~"}
  end
  return config
end

return configureIfWindows(
  configureDisplay(
  bindKeys(
  disableUnwantedFeatures(
  getDefaultConfig()))))

