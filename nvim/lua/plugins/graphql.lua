local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "graphql-language-service-cli", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("graphql")
end

return {
  "local/graphql",
  config = configure,
  ft = "graphql",
  virtual = true,
}
