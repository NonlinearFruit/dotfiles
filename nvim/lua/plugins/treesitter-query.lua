local function install_lsp_if_needed()
  require("installer").install_if_missing({
    "ts_query_ls", -- LSP
  })
end

local function configure()
  install_lsp_if_needed()
  vim.lsp.enable("ts_query_ls")
end

return {
  "local/treesitter-query",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
  },
  config = configure,
  ft = "query",
  init = function()
    vim.filetype.add({ extension = { scm = "query" } })
  end,
  virtual = true,
}
