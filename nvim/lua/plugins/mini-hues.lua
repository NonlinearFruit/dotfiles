local function set_color_scheme()
  require('mini.hues').setup({
    background = '#1c1c1c',
    foreground = '#87afaf',
    saturation = 'medium'
  })
end

local function configure()
  set_color_scheme()
  vim.api.nvim_create_user_command("NonlinearFruitColorSchemeEnable", set_color_scheme, {})
end

return {
  "echasnovski/mini.hues",
  config = configure,
}
