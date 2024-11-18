local function configure()
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = "all",
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
