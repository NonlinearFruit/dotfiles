local function configure()
  vim.bo.filetype = "crontab"
end

return {
  "local/crontab",
  config = configure,
  event = "BufEnter *.crontab",
  dev = true,
}
