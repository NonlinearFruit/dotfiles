local function configure()
  require("installer").install_if_missing({
    "marksman", -- LSP requires `sudo dnf install libicu` or `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1`
  })
  vim.bo.filetype = "markdown"
  vim.lsp.enable("marksman")
end

return {
  "local/markdown",
  config = configure,
  ft = "markdown",
  event = "BufEnter *.page",
  virtual = true,
}
