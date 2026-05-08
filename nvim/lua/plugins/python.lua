local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "pylyzer", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
end

return {
  "local/python",
  config = configure,
  ft = "py",
  virtual = true,
}
