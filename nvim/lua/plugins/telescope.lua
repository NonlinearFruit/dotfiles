-- Requires: (install with `./init.sh tools`)
-- cargo install ripgrep
-- cargo install fd-find

local function configure()
  local telescope = require("telescope")
  telescope.load_extension("fzf")
  local prefix = "<leader>/"
  vim.keymap.set(
    "n",
    prefix .. "/",
    require("telescope.builtin").current_buffer_fuzzy_find,
    { desc = "[/] Search Fuzzy Find [/] (search search)" }
  )
  vim.keymap.set("n", prefix .. "?", require("telescope.builtin").man_pages, { desc = "[/] Search [M]an Pages" })
  vim.keymap.set("n", prefix .. "a", require("telescope.builtin").builtin, { desc = "[/] Search [A]ll" })
  vim.keymap.set("n", prefix .. "b", require("telescope.builtin").buffers, { desc = "[/] Search [B]uffers" })
  vim.keymap.set("n", prefix .. "c", require("telescope.builtin").commands, { desc = "[/] Search [C]ommands" })
  vim.keymap.set(
    "n",
    prefix .. "f",
    require("telescope.builtin").find_files,
    { desc = "[/] Search [F]iles (all in working directory)" }
  )
  vim.keymap.set("n", prefix .. "g", require("telescope.builtin").live_grep, { desc = "[/] Search with [G]rep" })
  vim.keymap.set("n", prefix .. "h", require("telescope.builtin").help_tags, { desc = "[/] Search [H]elp" })
  vim.keymap.set("n", prefix .. "k", require("telescope.builtin").keymaps, { desc = "[/] Search [K]eymaps" })
  vim.keymap.set(
    "n",
    prefix .. "l",
    require("telescope.builtin").git_files,
    { desc = "[/] Search Git Files [L] (ls git stuff?)" }
  )
  vim.keymap.set("n", prefix .. "m", require("telescope.builtin").marks, { desc = "[/] Search [M]arks" })
  vim.keymap.set("n", prefix .. "r", require("telescope.builtin").registers, { desc = "[/] Search [R]egisters" })
  vim.keymap.set("n", prefix .. "s", require("telescope.builtin").spell_suggest, { desc = "[/] Search [S]pell" })
  vim.keymap.set("n", prefix .. "t", function()
    require("telescope.builtin").live_grep({ cwd = "~/projects/dotfiles/cheatsheets", disable_coordinates = true })
  end, { desc = "[/] Search [T]LDR style notes" })
  vim.keymap.set(
    "n",
    prefix .. "w",
    require("telescope.builtin").lsp_dynamic_workspace_symbols,
    { desc = "[/] Search [W]orkspace Symbols" }
  )
  vim.keymap.set(
    "n",
    prefix .. "y",
    require("telescope.builtin").git_branches,
    { desc = "[/] Search Git Branches [Y] (looks like branching)" }
  )
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
      config = configure
    },
  },
}
