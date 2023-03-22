vim.g.VimuxResetSequence = ""
vim.keymap.set("n", "<leader>vd", "<cmd>VimuxCloseRunner<cr>") -- [V]imux [D]elete
vim.keymap.set("n", "<leader>vp", "<cmd>VimuxPromptCommand<cr>") -- [V]imux [P]rompt
vim.keymap.set("n", "<leader>vz", "<cmd>VimuxZoomRunner<cr>") -- [V]imux [Z]oom (tmux <leader>-z to toggle https://superuser.com/a/576505/468052)

local cSharpTmux = vim.api.nvim_create_augroup("CSharpTmux", {clear = true})
local function keymap(key, cmd)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = cSharpTmux,
    pattern = { "*.cs" },
    callback = function() vim.keymap.set("n", "<leader>"..key, "<cmd>"..cmd.."<cr>") end
  })
end
local function vimuxkeymap(key, shellCommand)
  keymap(key, "VimuxRunCommand('"..shellCommand.."')")
end

keymap("fi", "OmniSharpFixUsings") -- [F]ix [I]mports
keymap("rr", "OmniSharpRename") -- [R]efactor [R]ename
keymap("rf", "OmniSharpCodeFormat") -- [R]efactor [F]ormat
keymap("gi", "OmniSharpFindImplementations") -- [G]oto [I]plementations
keymap("gd", "OmniSharpGotoDefinition") -- [G]oto [D]efinition
keymap("fu", "OmniSharpFindUsages") -- [F]ind [U]sages
vim.api.nvim_create_autocmd("BufEnter", {
  group = cSharpTmux,
  pattern = { "*.cs" },
  callback = function() vim.keymap.set("n", "gd", "<cmd>OmniSharpGotoDefinition<cr>") end
})
vimuxkeymap("at", "dotnet test") -- [A]ll [T]ests
vimuxkeymap("bc", "dotnet build") -- [B]uild/[C]ompile
vimuxkeymap("er", "dotnet run") -- [E]xecute [R]un

-- keymap("", "OmniSharpGetCodeActions") -- [] []
-- keymap("", "OmniSharpGlobalCodeCheck") -- [] []
-- keymap("", "OmniSharpNavigateDown") -- [] []
-- keymap("", "OmniSharpNavigateUp") -- [] []
-- keymap("", "OmniSharpPreviewDefinition") -- [] []
-- keymap("", "OmniSharpPreviewImplementation") -- [] []
-- keymap("", "OmniSharpReloadProject [{project}]") -- [] []
-- keymap("", "OmniSharpRepeatCodeAction") -- [] []
-- keymap("", "OmniSharpTypeLookup") -- [] []
