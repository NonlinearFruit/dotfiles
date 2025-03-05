local function configure_lsp()
  local lsp = require("language-server")
  local lsp_config_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_config_ok then
    return
  end

  lsp_config.nushell.setup({
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
  })
end

local function configure()
  -- lsp comes with nushell out-of-the-box
  configure_lsp()
  vim.bo.commentstring = "# %s"
end

return {
  "local/nushell",
  config = configure,
  ft = "nu",
  virtual = true,
}
