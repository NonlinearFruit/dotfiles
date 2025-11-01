local function configure()
  require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
      enable = true,
    },
  })
end

-- Print directory with treesitter parsers
-- :lua= require("nvim-treesitter.configs").get_parser_install_dir()

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = configure,
}
