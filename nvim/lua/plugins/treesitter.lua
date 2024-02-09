local function configure()
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = {
      "bash",
      "c_sharp",
      "javascript",
      "jq",
      "json",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "toml",
      "vim",
      "vimdoc",
      "yaml",
    },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = configure,
}
