local function configure()
  require("oil").setup()
  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Browse parent directory" })
end

return {
  "stevearc/oil.nvim",
  config = configure,
}
