-- Inspiration: https://github.com/fouladi/toggle-overlength.nvim
local api = vim.api
local overlength_active = false
local config = {
  column_length = 80, -- Default column length
  terminal_background = "darkgrey", -- Default background color for terminal
  gui_background = "#592929", -- Default background color for GUI
}

local function enable_overlength_mode()
  vim.cmd(string.format("highlight OverLength ctermbg=%s guibg=%s", config.terminal_background, config.gui_background))
  vim.opt.colorcolumn = tostring(config.column_length)
  vim.fn.matchadd("OverLength", string.format("\\%%%dv.\\+", config.column_length + 1))
  overlength_active = false
end

local function disable_overlength_mode()
  vim.cmd("highlight clear OverLength")
  vim.opt.colorcolumn = "0"
  overlength_active = true
end

local function configure()
  api.nvim_create_user_command("OverlengthEnable", enable_overlength_mode, {})
  api.nvim_create_user_command("OverlengthDisable", disable_overlength_mode, {})
end

return {
  "prototypes/overlength",
  config = configure,
  dev = true,
}
