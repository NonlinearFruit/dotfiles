local function configure()
  local null_ls = require("null-ls")

  local INSTALL_THESE = {
    -- Linters
    { name = "golangci-lint", should_install = true }, -- Go
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
