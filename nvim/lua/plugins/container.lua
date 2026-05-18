local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "dockerfile-language-server", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("dockerls")
end

return {
  "local/container",
  config = configure,
  ft = "dockerfile",
  virtual = true,
}
