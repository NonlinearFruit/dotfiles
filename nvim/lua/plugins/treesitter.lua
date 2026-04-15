-- Print directory with treesitter parsers
-- :lua= require("nvim-treesitter.configs").get_parser_install_dir()

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  opts = {
    auto_install = true,
    highlight = {
      enable = true,
    },
  },
}
