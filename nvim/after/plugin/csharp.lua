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

if os.execute("command -v rg > /dev/null") == 0 then
  vim.api.nvim_create_autocmd("BufEnter", {
    group = csharp,
    pattern = { "*.cs" },
    callback = function()
      vim.keymap.set("n", "<leader>gt", function()
        local currentFile = vim.api.nvim_buf_get_name(0)
        local currentFileName = currentFile:match("[^/]+$")
        local testFileName = currentFileName:gsub("%.cs", "Tests.cs")
        vim.fn.jobstart("rg --files | rg "..testFileName, {
          stdout_buffered = true,
          on_stdout = function(_, data)
            if data and data[1] and data[1] ~= "" then
              vim.cmd("tab drop "..data[1])
            else
              print("No test file found")
            end
          end
        })
      end, { desc = "[g]o to [t]est file" })
    end,
  })
end

if packer_plugins["vimux"] and packer_plugins["vimux"].loaded then
  local function vimuxkeymap(key, shellCommand, description)
    keymap(key, "wa | VimuxRunCommand('" .. shellCommand .. "')", description)
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
