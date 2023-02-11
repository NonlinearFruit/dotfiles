vim.g.mapleader = ' '

vim.g.VimuxResetSequence = ""
vim.keymap.set("n", "<leader>vd", "<cmd>VimuxCloseRunner<cr>") -- [V]imux [D]elete
vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<cr>") -- [V]imux [P]rompt
vim.keymap.set("n", "<leader>vz", "<cmd>VimuxZoomRunner<cr>") -- [V]imux [Z]oom

local cSharpTmux = vim.api.nvim_create_augroup("CSharpTmux", {clear = true})
local function keymap(key, shellCommand)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = cSharpTmux,
    pattern = { "*.cs" },
    callback = function() vim.keymap.set("n", "<leader>"..key, "<cmd>VimuxRunCommand('"..shellCommand.."')<cr>") end
  })
end

keymap("at", "dotnet test") -- [A]ll [T]ests
keymap("bc", "dotnet build") -- [B]uild/[C]ompile

-- :OmniSharpFixUsings
-- :OmniSharpGotoDefinition [{cmd}]
