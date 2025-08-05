local function send_current_file_to_another_nvim_server()
  require("prototypes/nvim-servers").send(require("telescope.themes").get_dropdown({}), vim.api.nvim_buf_get_name(0))
end

local function configure()
  vim.keymap.set(
    { "n", "v" },
    "<leader>ns",
    send_current_file_to_another_nvim_server,
    { desc = "[n]vim [s]end current file to another nvim instance" }
  )
end

return {
  "prototypes/nvim-servers",
  config = configure,
  virtual = true,
}
