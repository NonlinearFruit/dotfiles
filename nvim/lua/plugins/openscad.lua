local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "openscad-lsp", -- LSP
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("openscad_lsp")
end

return {
  "local/openscad",
  config = configure,
  ft = "openscad",
  virtual = true,
}
