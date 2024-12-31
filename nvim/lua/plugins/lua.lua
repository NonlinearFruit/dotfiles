local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "stylua", -- Formatter
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

  lsp_config.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

local function configure_lazydev()
  require("lazydev").setup({
    library = {
      -- Load the wezterm types when the `wezterm` module is required
      -- Needs `justinsgithub/wezterm-types` to be installed
      { path = "wezterm-types", mods = { "wezterm" } },
    },
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  configure_lsp()
  configure_lazydev()
end

return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  config = configure,
}
