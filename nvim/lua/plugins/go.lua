local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "golangci-lint", -- Linter
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

local function configure()
  install_lsp_and_dap_if_needed()
end

return {
  "local/go",
  config = configure,
  ft = "go",
  virtual = true,
}
