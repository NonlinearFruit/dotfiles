local function non_standard_options()
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
end

local function go_to_test_file_key_mapping()
  if os.execute("command -v rg > /dev/null") == 0 then
    vim.keymap.set("n", "<leader>gt", function()
      local currentFile = vim.api.nvim_buf_get_name(0)
      local currentFileName = currentFile:match("[^/]+$")
      local testFileName = currentFileName:gsub("%.cs", "Tests.cs")
      vim.fn.jobstart("rg --files | rg " .. testFileName, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and data[1] and data[1] ~= "" then
            vim.cmd("tab drop " .. data[1])
          else
            print("No test file found")
          end
        end,
      })
    end, { desc = "[g]o to [t]est file" })
  end
end

local function runner_key_mappings()
  local function runner_keymap(key, shellCommand, description)
    vim.keymap.set(
      "n",
      "<leader>" .. key,
      "<cmd>wa | lua require('runner').run('" .. shellCommand .. "')<cr>",
      { desc = description }
    )
  end

  runner_keymap("at", "dotnet test", "[A]ll [T]ests")
  runner_keymap("bc", "dotnet build", "[B]uild/[C]ompile")
  runner_keymap("er", "dotnet run", "[E]xecute [R]un")
end

local function configure()
  non_standard_options()
  go_to_test_file_key_mapping()
  runner_key_mappings()
end

return {
  "local/csharp",
  config = configure,
  ft = "cs",
  dev = true,
}
