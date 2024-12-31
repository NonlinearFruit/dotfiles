local function configure()
  require("nvim-treesitter.configs").setup({
    auto_install = true,
    highlight = {
      enable = true,
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = configure,
}
