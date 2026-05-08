local capabilities = {}
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities()
end

local on_attach = function(client, bufnr)
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, { buffer = bufnr, remap = false, desc = "[g]oto [d]efinition" })
  vim.keymap.set("n", "<leader>gd", function()
    vim.lsp.buf.definition()
  end, { buffer = bufnr, remap = false, desc = "[g]oto [d]efinition" })
  vim.keymap.set("n", "<leader>gr", function()
    vim.lsp.buf.references()
  end, { buffer = bufnr, remap = false, desc = "[g]oto [r]eferences" })
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
  end, { buffer = bufnr, remap = false, desc = "[K]now what this is" })
  vim.keymap.set({ "n", "i", "v" }, "<c-k>", function()
    vim.diagnostic.open_float()
  end, { buffer = bufnr, remap = false, desc = "[k]now what is wrong" })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
  end, { buffer = bufnr, remap = false, desc = "[]] Next [d]iagnostic" })
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
  end, { buffer = bufnr, remap = false, desc = "[[] Previous [d]iagnostic" })
  vim.keymap.set({ "n", "v" }, "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, { buffer = bufnr, remap = false, desc = "[c]ode [a]ctions" })
  vim.keymap.set({ "n", "v" }, "<leader>rr", function()
    vim.lsp.buf.rename()
  end, { buffer = bufnr, remap = false, desc = "[r]efactor [r]ename" })

  -- vim.keymap.set("i", "<C-h>", function() -- <c-h> is a bad mapping
  --   vim.lsp.buf.signature_help()
  -- end, { buffer = bufnr, remap = false })
  vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
  end, { buffer = bufnr, remap = false })
  vim.keymap.set("n", "=", function()
    vim.lsp.buf.format()
  end, { buffer = bufnr, remap = false, desc = "[=] Format file" })
end

-- :h grr
-- These GLOBAL keymaps are created unconditionally when Nvim starts:
-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
-- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|

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

-- https://www.reddit.com/r/neovim/comments/1jw0zav/comment/mmgcn5r/
local function enableLSPs()
  local lsp_configs = {}
  for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
    local server_name = vim.fn.fnamemodify(f, ":t:r")
    table.insert(lsp_configs, server_name)
  end
  vim.lsp.enable(lsp_configs)
end

local function configure()
  vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities,
  })
  enableLSPs()
end

return {
  "local/language-server",
  config = configure,
  lazy = false,
  virtual = true,
  on_attach = on_attach, -- For other plugins to use
  capabilities = capabilities,
}
