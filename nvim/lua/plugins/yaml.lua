local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "yaml-language-server", -- LSP
    "yamlfmt", -- Formatter
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

  lsp_config.yamlls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
        },
      },
    },
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  configure_lsp()
end

return {
  "local/yaml",
  config = configure,
  ft = "yaml",
  virtual = true,
}
