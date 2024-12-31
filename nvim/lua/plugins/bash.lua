local function configure()
  vim.bo.filetype = "bash"
end

return {
  "local/bash",
  config = configure,
  event = "BufEnter /tmp/bash-fc*",
  virtual = true,
}
