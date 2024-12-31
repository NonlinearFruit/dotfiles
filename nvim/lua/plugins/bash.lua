local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "bash-language-server", -- LSP
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

local function configure_lsp()
  local lsp = require("language-server")
  local lsp_config_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_config_ok then
    return
  end

  lsp_config.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  configure_lsp()
  vim.bo.filetype = "sh"
end

return {
  "local/bash",
  config = configure,
  event = "BufEnter /tmp/bash-fc*",
  ft = "sh",
  virtual = true,
}
