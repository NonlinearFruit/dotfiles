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

vim.keymap.set('n', '<leader>lsp', '<cmd>Mason<cr>', { desc = '[LSP] Manage language server installs' })

local INSTALL_THESE = {
  -- Language Server Protocol (LSP) implementations that are configured are installed,
  -- Debug Adapter Protocol (DAP) implementations,
  "codelldb",   -- Rust
  "netcoredbg", -- C#
  -- Linters
  "selene",     -- Lua
  -- Formatters
  "stylua",     -- Lua
}
for _, pkg in ipairs(INSTALL_THESE) do
  if not require("mason-registry").is_installed(pkg) then require("mason.api.command").MasonInstall { pkg } end
end

