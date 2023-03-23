-- Requires
  -- sudo apt-get install ripgrep
  -- sudo apt install fd-find

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

telescope.load_extension('fzf')

local prefix = "<leader>/"
vim.keymap.set("n", prefix.."/", require('telescope.builtin').current_buffer_fuzzy_find, { desc = "[/] Search Fuzzy Find [/] (search search)" })
vim.keymap.set("n", prefix.."?", require('telescope.builtin').man_pages, { desc = "[/] Search [M]an Pages" })
vim.keymap.set("n", prefix.."a", require('telescope.builtin').builtin, { desc = "[/] Search [A]ll" })
vim.keymap.set("n", prefix.."b", require('telescope.builtin').buffers, { desc = "[/] Search [B]uffers" })
vim.keymap.set("n", prefix.."c", require('telescope.builtin').commands, { desc = "[/] Search [C]ommands" })
vim.keymap.set("n", prefix.."f", require('telescope.builtin').find_files, { desc = "[/] Search [F]iles (all in working directory)" })
vim.keymap.set("n", prefix.."g", require('telescope.builtin').live_grep, { desc = "[/] Search with [G]rep" })
vim.keymap.set("n", prefix.."h", require('telescope.builtin').help_tags, { desc = "[/] Search [H]elp" })
vim.keymap.set("n", prefix.."k", require('telescope.builtin').keymaps, { desc = "[/] Search [K]eymaps" })
vim.keymap.set("n", prefix.."l", require('telescope.builtin').git_files, {desc = "[/] Search Git Files [L] (ls git stuff?)" })
vim.keymap.set("n", prefix.."m", require('telescope.builtin').marks, { desc = "[/] Search [M]arks" })
vim.keymap.set("n", prefix.."r", require('telescope.builtin').registers, { desc = "[/] Search [R]egisters" })
vim.keymap.set("n", prefix.."s", require('telescope.builtin').spell_suggest, { desc = "[/] Search [S]pell" })
vim.keymap.set("n", prefix.."y", require('telescope.builtin').git_branches, { desc = "[/] Search Git Branches [Y] (looks like branching)" })

-- Telescope builtins
  -- autocommands
  -- colorscheme
  -- command_history
  -- current_buffer_fuzzy_find
  -- current_buffer_tags
  -- diagnostics
  -- fd
  -- filetypes
  -- git_bcommits
  -- git_commits
  -- git_stash
  -- git_status
  -- grep_string
  -- highlights
  -- jumplist
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
  -- oldfiles
  -- pickers
  -- planets
  -- quickfix
  -- quickfixhistory
  -- reloader
  -- resume
  -- search_history
  -- symbols
  -- tags
  -- tagstack
  -- treesitter
  -- vim_options
