local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "gopls", -- LSP
    "golangci-lint", -- Linter
    "delve", -- DAP
  })
end

local function configure_dap()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
    options = {
      initialize_timeout_sec = 20
    },
  }

  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug file",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = function()
        return require("dap.utils").pick_process({})
      end,
    },
  }
end

local function configure()
  install_lsp_and_dap_if_needed()
  configure_dap()
  vim.lsp.enable("gopls")
end

return {
  "local/go",
  config = configure,
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  ft = "go",
  virtual = true,
}
