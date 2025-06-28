local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "graphql-language-service-cli", -- LSP
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
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
