local function configure()
  require('mini.hues').setup({ background = '#271302', foreground = '#AEA59F', saturation = 'low', n_hues = 8 })
end

return {
  'echasnovski/mini.hues',
  version = '*',
  config = configure,
}
