local function configure()
  vim.bo.filetype = "markdown"
end

return {
  "local/markdown",
  config = configure,
  event = "BufEnter *.page",
  virtual = true,
}
