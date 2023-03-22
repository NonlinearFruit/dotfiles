-- Requires
  -- sudo apt-get install ripgrep
  -- sudo apt install fd-find

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

telescope.load_extension('fzf')

local prefix = "<leader>/"
vim.keymap.set("n", prefix.."a", require('telescope.builtin').builtin, { desc = "[/] Search [A]ll" })
vim.keymap.set("n", prefix.."b", require('telescope.builtin').buffers, { desc = "[/] Search [B]uffers" })
vim.keymap.set("n", prefix.."c", require('telescope.builtin').commands, { desc = "[/] Search [C]ommands" })
vim.keymap.set("n", prefix.."f", require('telescope.builtin').current_buffer_fuzzy_find, { desc = "[/] Search [F]uzzy Find" })
vim.keymap.set("n", prefix.."h", require('telescope.builtin').help_tags, { desc = "[/] Search [H]elp" })
vim.keymap.set("n", prefix.."k", require('telescope.builtin').keymaps, { desc = "[/] Search [K]eymaps" })
vim.keymap.set("n", prefix.."r", require('telescope.builtin').registers, { desc = "[/] Search [R]egisters" })
vim.keymap.set("n", prefix.."s", require('telescope.builtin').spell_suggest, { desc = "[/] Search [S]pell" })

-- Telescope commands to map
  -- git_branches
  -- git_files
  -- live_grep
  -- man_pages
  -- marks

-- Telescope builtins
  -- autocommands
  -- buffers
  -- builtin
  -- colorscheme
  -- command_history
  -- commands
  -- current_buffer_fuzzy_find
  -- current_buffer_tags
  -- diagnostics
  -- fd
  -- filetypes
  -- find_files
  -- git_bcommits
  -- git_branches
  -- git_commits
  -- git_files
  -- git_stash
  -- git_status
  -- grep_string
  -- help_tags
  -- highlights
  -- jumplist
  -- keymaps
  -- live_grep
  -- loclist
  -- lsp_definitions
  -- lsp_document_symbols
  -- lsp_dynamic_workspace_symbols
  -- lsp_implementations
  -- lsp_incoming_calls
  -- lsp_outgoing_calls
  -- lsp_references
  -- lsp_type_definitions
  -- lsp_workspace_symbols
  -- man_pages
  -- marks
  -- oldfiles
  -- pickers
  -- planets
  -- quickfix
  -- quickfixhistory
  -- registers
  -- reloader
  -- resume
  -- search_history
  -- spell_suggest
  -- symbols
  -- tags
  -- tagstack
  -- treesitter
  -- vim_options
