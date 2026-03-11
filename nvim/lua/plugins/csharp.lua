local function non_standard_options()
  vim.opt.tabstop = 4
  vim.opt.softtabstop = 4
  vim.opt.shiftwidth = 4
end

local function go_to_test_file_key_mapping()
  if os.execute("command -v rg > /dev/null") == 0 then
    vim.keymap.set("n", "<leader>gt", function()
      local current_file_stem = vim.fn.expand("%:t:r")
      local test_file_name = current_file_stem .. "Tests.cs"
      vim.fn.jobstart("rg --files | rg " .. test_file_name, {
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

local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    -- "roslyn", -- LSP Needs to be manually installed from the Mason gui?
    "netcoredbg", -- DAP
  })
end

local function configure_dap()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  dap.adapters.netcoredbg = {
    type = "executable",
    command = "netcoredbg",
    args = { "--interpreter=vscode" },
  }

  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "launch - netcoredbg",
      request = "launch",
      program = function()
        local cwd = vim.fn.getcwd()
        local d = vim.fn.fnamemodify(cwd, ":t")
        return vim.fn.input("Path to dll: ", cwd .. "/bin/Debug/net9.0/" .. d .. ".dll", "file")
      end,
    },
    {
      type = "netcoredbg",
      name = "attach - netcoredbg",
      request = "attach",
      processId = function()
        local pgrep = vim.fn.system("pgrep -f 'dotnet run'")
        vim.fn.setenv("NETCOREDBG_ATTACH_PID", pid)
        return tonumber(pgrep)
      end,
    },
  }
end

local function configure()
  non_standard_options()
  go_to_test_file_key_mapping()
  runner_key_mappings()
  install_lsp_and_dap_if_needed()
  configure_dap()
end

return {
  "local/csharp",
  config = configure,
  ft = "cs",
  virtual = true,
  dependencies = {
    "seblyng/roslyn.nvim", -- c# lsp
  },
}
