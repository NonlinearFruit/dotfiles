local function configure()
  require("installer").install_if_missing({
    "marksman", -- LSP requires `sudo dnf install libicu` or `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1`
  })
  vim.opt_local.filetype = "markdown"
  vim.opt_local.spell = true
  vim.opt_local.textwidth = 80
end

return {
  "local/markdown",
  config = configure,
  ft = "markdown",
  event = "BufEnter *.page",
  virtual = true,
}
