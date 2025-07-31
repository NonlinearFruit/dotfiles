local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "gopls", -- LSP
    "golangci-lint", -- Linter
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("gopls")
end

return {
  "local/go",
  config = configure,
  ft = "go",
  virtual = true,
}
