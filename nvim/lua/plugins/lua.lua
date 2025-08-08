local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "lua-language-server", -- LSP
    "stylua", -- Formatter
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.lsp.enable("lua-language-server")
  require("lazydev").setup()
end

return {
  "folke/lazydev.nvim",
  ft = "lua",
  config = configure,
}
