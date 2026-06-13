local function configure()
  vim.filetype.add({
    extension = { xaml = "xml", props = "xml", csproj = "xml" },
  })
end

return {
  "local/xml",
  config = configure,
  event = { "BufEnter *.xaml,*.props,*.csproj" },
  virtual = true,
}
