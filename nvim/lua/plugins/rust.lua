local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "rust-analyzer", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("rust_analyzer")
end

return {
  "local/rust",
  config = configure,
  ft = "rust",
  virtual = true,
}
