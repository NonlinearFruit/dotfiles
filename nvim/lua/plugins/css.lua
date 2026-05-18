local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "css-lsp", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("css-lsp")
end

return {
  "local/css",
  config = configure,
  ft = "css",
  virtual = true,
}
