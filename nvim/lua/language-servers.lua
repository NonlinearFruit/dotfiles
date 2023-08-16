local lsp_ok, lsp_config = pcall(require, 'lspconfig')
if not lsp_ok then
  return
end
--
--vim.lsp.set_log_level('debug')

-- How diagnostics show up
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  signs = false
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local function on_attach(client, bufnr)
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = "[g]oto [d]efinition"})
  vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, {buffer = bufnr, remap = false, desc = "[g]oto [d]efinition"})
  vim.keymap.set("n", "<leader>gr", function() vim.lsp.buf.references() end, {buffer = bufnr, remap = false, desc = "[g]oto [r]eferences"})
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, {buffer = bufnr, remap = false, desc = "[K]now what this is"})
  vim.keymap.set({"n", "i", "v"}, "<c-k>", function() vim.diagnostic.open_float() end, {buffer = bufnr, remap = false, desc = "[k]now what is wrong"})
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, {buffer = bufnr, remap = false, desc = "[]] Next [d]iagnostic"})
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, {buffer = bufnr, remap = false, desc = "[[] Previous [d]iagnostic"})
  vim.keymap.set({"n", "v"}, "<leader>ca", function() vim.lsp.buf.code_action() end, {buffer = bufnr, remap = false, desc = "[c]ode [a]ctions"})
  vim.keymap.set({"n", "v"}, "<leader>rr", function() vim.lsp.buf.rename() end, {buffer = bufnr, remap = false, desc = "[r]efactor [r]ename"})

  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, {buffer = bufnr, remap = false})
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, {buffer = bufnr, remap = false})
  vim.keymap.set("n", "=", function() vim.lsp.buf.format() end, {buffer = bufnr, remap = false, desc = "[=] Format file"})
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

if os.execute('is termux') ~= 0 then
  lsp_config.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
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
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  }

  lsp_config.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities
  })

  lsp_config.pylyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities
  })

  lsp_config.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities
  })

  lsp_config.bashls.setup({
    on_attach = on_attach,
    capabilities = capabilities
  })

  lsp_config.dockerls.setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

lsp_config.omnisharp.setup({
  on_attach = function (client, bufnr)
    -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
    local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
    for i, v in ipairs(tokenModifiers) do
      local tmp = string.gsub(v, ' ', '_')
      tokenModifiers[i] = string.gsub(tmp, '-_', '')
    end
    local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
    for i, v in ipairs(tokenTypes) do
      local tmp = string.gsub(v, ' ', '_')
      tokenTypes[i] = string.gsub(tmp, '-_', '')
    end
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  handlers = {
    ["textDocument/definition"] = require('omnisharp_extended').handler
  }
})

vim.keymap.set('n', '<leader>lsp', '<cmd>Mason<cr>', { desc = '[LSP] Manage language server installs' })
