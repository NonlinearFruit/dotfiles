local function configure()
  vim.filetype.add({
    extension = { crontab = "crontab" },
  })
end

return {
  "local/crontab",
  config = configure,
  event = "BufEnter *.crontab",
  virtual = true,
}
