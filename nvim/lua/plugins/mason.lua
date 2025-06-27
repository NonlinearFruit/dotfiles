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
  "mason-org/mason-lspconfig.nvim", -- easier to configure mason
  dependencies = {
      "mason-org/mason.nvim", -- tool to install lsp/dap/linter/formatters
      "neovim/nvim-lspconfig", -- configure lsps
  },
  config = configure,
}
