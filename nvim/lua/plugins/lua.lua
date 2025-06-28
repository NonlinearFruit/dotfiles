local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "stylua", -- Formatter
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
  -- vim.lsp.enable("stylua")
  configure_lazydev()
end

return {
  "folke/lazydev.nvim",
  ft = "lua", -- only load on lua files
  config = configure,
}
