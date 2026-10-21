local function configure_dap()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end

  -- dap comes with nushell out-of-the-box
  dap.adapters.nushell = {
    type = "executable",
    command = "nu",
    args = { "--dap" },
  }

  dap.configurations.nu = {
    {
      type = "nushell",
      name = "launch - current file",
      request = "launch",
      program = "${file}",
    },
  }
end

local function configure()
  -- lsp comes with nushell out-of-the-box
  vim.lsp.enable("nushell")
  configure_dap()
end

return {
  "local/nushell",
  config = configure,
  ft = "nu",
  virtual = true,
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap", -- must load before configure_dap() runs on ft=nu
  },
}
