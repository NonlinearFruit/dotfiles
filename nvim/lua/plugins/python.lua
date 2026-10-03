local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "ty", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("ty")
end

return {
  "local/python",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = configure,
  ft = "python",
  virtual = true,
}
