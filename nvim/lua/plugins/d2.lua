local function configure()
  vim.cmd("TSInstall d2")
  vim.bo.filetype = "d2"
end

return {
  "ravsii/tree-sitter-d2",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufEnter *.d2",
  ft = "d2",
  build = "make nvim-install",
  config = configure,
}

-- And `:TSInstall d2`
