local function configure()
  require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = {
      "c_sharp",
      "lua",
      "vim",
      "python",
      "jq",
      "rust",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "latex",
      "json",
      "javascript",
      "bash",
    },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  })
end

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = configure,
}
