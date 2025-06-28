local function configure()
  -- lsp comes with nushell out-of-the-box
  vim.lsp.enable("nushell")
  vim.bo.commentstring = "# %s"
end

return {
  "local/nushell",
  config = configure,
  ft = "nu",
  virtual = true,
}
