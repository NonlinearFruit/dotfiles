local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  return
end

local mason_lsp_ok, mason_lsp_config = pcall(require, 'mason-lspconfig')
if not mason_lsp_ok then
  return
end

mason.setup({
  ui = {
    border = 'rounded'
  }
})

mason_lsp_config.setup({
  automatic_installation = true
})

require('language-servers')
