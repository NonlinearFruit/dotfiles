local function configure()
  require("oil").setup({
    keymaps = {
      ["~"] = false,
      ["<leader>/g"] = {
        callback = function()
          local dir = require("oil").get_current_dir()
          require("telescope.builtin").live_grep({ cwd = dir })
        end,
        desc = "[/] [g]rep current oil directory",
      },
    },
  })
  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Browse parent directory" })
end

return {
  "stevearc/oil.nvim",
  config = configure,
}
