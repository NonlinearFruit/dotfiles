local function configure()
  require('mini.comment').setup()
end

return {
  'echasnovski/mini.comment',
  version = '*',
  config = configure,
}
