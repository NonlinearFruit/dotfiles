local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
  return
end

local mason_lsp_ok, mason_lsp_config = pcall(require, 'mason-lspconfig')
if not mason_lsp_ok then
  return
end

local lsp_ok, lsp_config = pcall(require, 'lspconfig')
if not lsp_ok then
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

-- vim.lsp.set_log_level('debug')

-- How diagnostics show up
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = false
})

local function on_attach(client, bufnr)

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = "[G]oto [D]efinition"})
  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = "[G]oto [D]efinition"})
  vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, {buffer = bufnr, remap = false, desc = "[G]oto [R]eferences"})
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {buffer = bufnr, remap = false, desc = "[K]now what this is"})
  vim.keymap.set({"n", "i", "v"}, "<c-k>", function() vim.diagnostic.open_float() end, {buffer = bufnr, remap = false, desc = "[K]now what is wrong"})
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, {buffer = bufnr, remap = false, desc = "[[] Next [d]iagnostic"})
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, {buffer = bufnr, remap = false, desc = "[]] Previous [d]iagnostic"})
  vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, {buffer = bufnr, remap = false, desc = "[C]ode [A]ctions"})

  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, {buffer = bufnr, remap = false})
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, {buffer = bufnr, remap = false})
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, {buffer = bufnr, remap = false})
end

-- Unused vim.lsp.buf.*
  -- add_workspace_folder
  -- clear_references
  -- completion
  -- declaration
  -- document_highlight
  -- document_symbol
  -- execute_command
  -- format
  -- formatting
  -- formatting_seq_sync
  -- formatting_sync
  -- implementation
  -- incoming_calls
  -- list_workspace_folders
  -- outgoing_calls
  -- range_code_action
  -- range_formatting
  -- remove_workspace_folder
  -- server_ready
  -- type_definition

lsp_config.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

lsp_config.tsserver.setup({
  on_attach = on_attach
})

lsp_config.rust_analyzer.setup({
  on_attach = on_attach
})

lsp_config.bashls.setup({
  on_attach = on_attach
})

lsp_config.dockerls.setup({
  on_attach = on_attach
})

lsp_config.omnisharp.setup({
  on_attach = on_attach,
  --capabilities = capabilities,
  root_dir = lsp_config.util.root_pattern(".sln", ".csproj", ".git"),
})

vim.keymap.set('n', '<leader>lsp', '<cmd>Mason<cr>', { desc = '[LSP] Manage language server installs' })
