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
    -- Avoid WSL bug in file watching in dotnet runtime <https://github.com/seblyng/roslyn.nvim/issues/303#issuecomment-4144530656>
    "roslyn@5.4.0-2.26175.10", -- LSP Needs to be manually installed from the Mason gui?
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

  local function pick_runnable_dll()
    local helpers = require("helpers")
    local cwd = vim.fn.getcwd()

    -- Runnable projects emit <Name>.runtimeconfig.json next to <Name>.dll.
    local configs = vim.fn.glob(cwd .. "/**/bin/Debug/**/*.runtimeconfig.json", true, true)
    local dlls = {}
    for _, cfg in ipairs(configs) do
      table.insert(dlls, (cfg:gsub("%.runtimeconfig%.json$", ".dll")))
    end

    local selection
    if #dlls == 0 then
      selection = vim.fn.input("Path to dll: ", cwd .. "/", "file")
    elseif #dlls == 1 then
      selection = dlls[1]
    else
      selection = helpers.pick_one_sync("Select dlls to run", dlls)
    end

    if selection == nil or selection == "" then
      return dap.ABORT
    end
    return selection
  end

  dap.configurations.cs = {
    {
      type = "netcoredbg",
      name = "launch - netcoredbg",
      request = "launch",
      program = pick_runnable_dll,
    },
    {
      type = "netcoredbg",
      name = "attach - netcoredbg",
      request = "attach",
      processId = function()
        return require("dap.utils").pick_process({
          filter = function(proc)
            return proc.name:match("bin/Debug") ~= nil or proc.name:match("bin/Release") ~= nil
          end,
        })
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
  vim.cmd.compiler("dotnet")
end

return {
  "local/csharp",
  config = configure,
  ft = "cs",
  virtual = true,
  dependencies = {
    "seblyng/roslyn.nvim", -- c# lsp
    "mfussenegger/nvim-dap", -- must load before configure_dap() runs on ft=cs
  },
}
