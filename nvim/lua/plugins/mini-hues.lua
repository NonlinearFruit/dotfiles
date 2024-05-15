local function configure()
  require('mini.hues').setup({
    background = '#1c1c1c',
    foreground = '#87afaf',
    saturation = 'low',
  })
end

return {
  'echasnovski/mini.hues',
  version = '*',
  config = configure,
}
