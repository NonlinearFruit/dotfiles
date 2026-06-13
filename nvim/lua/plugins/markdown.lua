local function set_options()
  vim.opt_local.spell = true
  vim.opt_local.textwidth = 80
end

local function configure()
  require("installer").install_if_missing({
    "marksman", -- LSP requires `sudo dnf install libicu` or `DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1`
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = set_options,
  })
  set_options()
  vim.lsp.enable("marksman")
end

return {
  "local/markdown",
  config = configure,
  ft = "markdown",
  virtual = true,
}
