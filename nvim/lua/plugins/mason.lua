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

  local lsp = require("language-server")
  local capabilities = lsp.capabilities
  local on_attach = lsp.on_attach
  local lsp_config_ok, lsp_config = pcall(require, "lspconfig")
  if not lsp_config_ok then
    return
  end

  if os.execute("is termux") ~= 0 then
    lsp_config.bashls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.dockerls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.graphql.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    lsp_config.openscad_lsp.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

return {
  "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- easier to configure mason
    "neovim/nvim-lspconfig", -- configure lsps
  },
  config = configure,
}
