local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "yaml-language-server", -- LSP
    "yamlfmt", -- Formatter
  })
end

local function configure_lsp()
  vim.lsp.config("yamlls", {
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
  vim.lsp.enable("yamlls")
end

return {
  "local/yaml",
  config = configure,
  ft = "yaml",
  virtual = true,
}
