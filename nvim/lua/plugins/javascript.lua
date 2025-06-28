local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "typescript-language-server", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("ts_ls")
end

return {
  "local/javascript",
  config = configure,
  ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  virtual = true,
}
