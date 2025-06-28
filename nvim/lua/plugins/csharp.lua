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

local function install_lsp_and_dap_if_needed()
  local INSTALL_THESE = {
    "omnisharp", -- LSP
    "netcoredbg", -- DAP
  }
  for _, pkg in ipairs(INSTALL_THESE) do
    if not require("mason-registry").is_installed(pkg) then
      require("mason.api.command").MasonInstall({ pkg })
    end
  end
end

local function configure_lsp()
  local lsp = require("plugins.language-server")

  vim.lsp.config("omnisharp", {
    cmd = {
      vim.fn.executable('OmniSharp') == 1 and 'OmniSharp' or 'omnisharp',
      '-z', -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
      '--hostPID',
      tostring(vim.fn.getpid()),
      'DotNet:enablePackageRestore=false',
      '--encoding',
      'utf-8',
      '--languageserver',
    },
    on_attach = function(client, bufnr)
      -- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
      local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
      for i, v in ipairs(tokenModifiers) do
        local tmp = string.gsub(v, " ", "_")
        tokenModifiers[i] = string.gsub(tmp, "-_", "")
      end
      local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
      for i, v in ipairs(tokenTypes) do
        local tmp = string.gsub(v, " ", "_")
        tokenTypes[i] = string.gsub(tmp, "-_", "")
      end
      lsp.on_attach(client, bufnr)
    end,
    handlers = {
      ["textDocument/definition"] = require("omnisharp_extended").handler,
    },
  })
  vim.lsp.enable("omnisharp")
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
  configure_lsp()
  configure_dap()
end

return {
  "local/csharp",
  config = configure,
  ft = "cs",
  virtual = true,
  dependencies = {
    "hoffs/omnisharp-extended-lsp.nvim", -- improve c# lsp
  },
}
