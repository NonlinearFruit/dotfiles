local status_null_ls_ok, null_ls = pcall(require, 'null-ls')
if not status_null_ls_ok then
  return
end

local INSTALL_THESE = {
  -- Linters
  -- "selene",      -- Lua (GLIBC_2.32 not found)
  "golangci-lint",  -- Go
  -- Formatters
  "stylua",         -- Lua
  "yamlfmt",        -- YAML
}
for _, pkg in ipairs(INSTALL_THESE) do
  if not require("mason-registry").is_installed(pkg) then require("mason.api.command").MasonInstall { pkg } end
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  debug = false,
  sources = {
    formatting.stylua,
    formatting.yamlfmt,
    -- diagnostics.selene,
    diagnostics.golangci_lint
  }
})
