local function configure()
  vim.bo.filetype = "xml"
end

return {
  "local/xml",
  config = configure,
  event = { "BufEnter *.xaml,*.props,*.csproj" },
  virtual = true,
}
