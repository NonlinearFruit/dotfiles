local function install_lsp_and_dap_if_needed()
  require("installer").install_if_missing({
    "bash-language-server", -- LSP
  })
end

local function configure()
  install_lsp_and_dap_if_needed()
  vim.filetype.add({
    pattern = { ["/tmp/bash%-fc.*"] = "sh" },
  })
  vim.lsp.enable("bashls")
end

return {
  "local/bash",
  config = configure,
  event = "BufEnter /tmp/bash-fc*",
  ft = "sh",
  virtual = true,
}
