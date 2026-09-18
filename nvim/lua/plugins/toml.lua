local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "taplo", -- LSP
  })
end

local function configure_lsp()
  vim.lsp.config("taplo", {
    settings = {
      evenBetterToml = {
        schema = {
          associations = {
            ["mise.*\\.toml$"] = "https://mise.jdx.dev/schema/mise.json",
          },
        },
      },
    },
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  configure_lsp()
  vim.lsp.enable("taplo")
end

return {
  "local/toml",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = configure,
  ft = "toml",
  virtual = true,
}
