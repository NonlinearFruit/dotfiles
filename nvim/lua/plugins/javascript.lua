local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "typescript-language-server", -- LSP
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("ts_ls")
end

return {
  "local/javascript",
  config = configure,
  ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  virtual = true,
}
