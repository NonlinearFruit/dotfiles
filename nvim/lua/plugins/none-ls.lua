local function configure()
  local null_ls = require("null-ls")

  local INSTALL_THESE = {
    -- Linters
    -- { name = "selene", should_install = true },      -- Lua (GLIBC_2.32 not found)
    { name = "golangci-lint", should_install = true }, -- Go
    -- Formatters
    { name = "stylua", should_install = os.execute("is termux") ~= 0 }, -- Lua
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if pkg.should_install and not require("mason-registry").is_installed(pkg.name) then
      require("mason.api.command").MasonInstall({ pkg.name })
    end
  end

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    debug = false,
    sources = {
      formatting.stylua,
      formatting.yamlfmt,
      -- diagnostics.selene,
      diagnostics.golangci_lint,
    },
  })
end

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
  },
  config = configure,
}
