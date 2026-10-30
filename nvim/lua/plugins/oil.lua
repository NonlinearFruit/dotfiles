local function configure_oil()
  require("oil").setup({
    win_options = {
      signcolumn = "yes:1",
    },
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

local function symbols_for(letter)
  local changed = { "A", "C", "D", "M", "R", "T", "U" }
  local symbols = { ["!"] = "", ["?"] = "", [" "] = "" }
  for _, code in ipairs(changed) do
    symbols[code] = letter
  end
  return symbols
end

local function configure_oil_git()
  local working_tree = symbols_for("w") -- [w]orking tree
  working_tree["?"] = "u" -- [u]ntracked
  require("oil-git-status").setup({
    symbols = {
      index = symbols_for("s"), -- [s]taged
      working_tree = working_tree,
    },
  })
end

local function configure()
  configure_oil()
  configure_oil_git()
end

return {
  "stevearc/oil.nvim",
  dependencies = { "refractalize/oil-git-status.nvim" },
  config = configure,
}
