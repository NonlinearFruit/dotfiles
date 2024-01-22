local function configure()
end

return {
  "LhKipp/nvim-nu",
  opts = {},
  config = configure,
  build = ':TSInstall nu',
  dependencies = { "nvim-treesitter/nvim-treesitter" }
}
