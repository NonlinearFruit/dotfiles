-- Inspiration: https://github.com/joshuadanpeterson/typewriter.nvim
local api = vim.api
local typewriter_active = false

local function enable_typewriter_mode()
  if not typewriter_active then
    typewriter_active = true
    vim.opt.scrolloff = 999 -- Keep cursor in vertical center
    vim.opt.sidescrolloff = 999 -- Keep cursor in horizontal center
  end
end

local function disable_typewriter_mode()
  if typewriter_active then
    typewriter_active = false
    vim.opt.scrolloff = 0 -- Default offset
    vim.opt.sidescrolloff = 0 -- Default offset
  end
end

local function configure()
  api.nvim_create_user_command("TypewriterEnable", enable_typewriter_mode, {})
  api.nvim_create_user_command("TyperwriterDisable", disable_typewriter_mode, {})
end

return {
  "prototypes/typewriter",
  config = configure,
  virtual = true,
}
