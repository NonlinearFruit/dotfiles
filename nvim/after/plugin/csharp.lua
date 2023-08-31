local csharp = vim.api.nvim_create_augroup("CSharp", { clear = true })

local function keymap(key, cmd, description)
  vim.api.nvim_create_autocmd("BufEnter", {
    group = csharp,
    pattern = { "*.cs" },
    callback = function()
      vim.keymap.set("n", "<leader>" .. key, "<cmd>" .. cmd .. "<cr>", { desc = description })
    end,
  })
end

vim.api.nvim_create_autocmd("BufEnter", {
  group = csharp,
  pattern = { "*.cs" },
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
  end,
})

if packer_plugins["vimux"] and packer_plugins["vimux"].loaded then
  local function vimuxkeymap(key, shellCommand, description)
    keymap(key, "VimuxRunCommand('" .. shellCommand .. "')", description)
  end

  vimuxkeymap("at", "dotnet test", "[A]ll [T]ests")
  vimuxkeymap("bc", "dotnet build", "[B]uild/[C]ompile")
  vimuxkeymap("er", "dotnet run", "[E]xecute [R]un")
end

if packer_plugins["omnisharp-vim"] and packer_plugins["omnisharp-vim"].loaded then
  keymap("fi", "OmniSharpFixUsings", "[F]ix [I]mports")
  -- keymap("rr", "OmniSharpRename", "[R]efactor [R]ename")
  keymap("rf", "OmniSharpCodeFormat", "[R]efactor [F]ormat")
  keymap("gi", "OmniSharpFindImplementations", "[G]oto [I]plementations")
  -- keymap("", "OmniSharpGetCodeActions") -- [] []
  -- keymap("", "OmniSharpGlobalCodeCheck") -- [] []
  -- keymap("", "OmniSharpNavigateDown") -- [] []
  -- keymap("", "OmniSharpNavigateUp") -- [] []
  -- keymap("", "OmniSharpPreviewDefinition") -- [] []
  -- keymap("", "OmniSharpPreviewImplementation") -- [] []
  -- keymap("", "OmniSharpReloadProject [{project}]") -- [] []
  -- keymap("", "OmniSharpRepeatCodeAction") -- [] []
  -- keymap("", "OmniSharpTypeLookup") -- [] []
end
