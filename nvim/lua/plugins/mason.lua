local function configure()
  local mason_ok, mason = pcall(require, "mason")
  if not mason_ok then
    return
  end

  local mason_lsp_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
  if not mason_lsp_ok then
    return
  end

  mason.setup({
    ui = {
      border = "rounded",
    },
  })

  mason_lsp_config.setup({
    automatic_installation = false,
  })

  --vim.lsp.set_log_level('debug')

  -- How diagnostics show up
  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    signs = false,
  })
end

return {
  "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- easier to configure mason
    "neovim/nvim-lspconfig", -- configure lsps
  },
  config = configure,
}
