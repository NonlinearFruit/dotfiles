-- :checkhealth telescope

-- Requires
  -- sudo apt-get install ripgrep
  -- sudo apt install fd-find

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

require('telescope').load_extension('fzf')

local prefix = "<leader>t"
vim.api.nvim_set_keymap("n", prefix.."a", "<cmd>Telescope builtins<cr>", { desc = "[T]elescope [A]ll" })
vim.api.nvim_set_keymap("n", prefix.."b", "<cmd>Telescope buffers<cr>", { desc = "[T]elescope [B]uffers" })
vim.api.nvim_set_keymap("n", prefix.."c", "<cmd>Telescope commands<cr>", { desc = "[T]elescope [C]ommands" })
vim.api.nvim_set_keymap("n", prefix.."f", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "[T]elescope [F]uzzy Find" })
vim.api.nvim_set_keymap("n", prefix.."h", "<cmd>Telescope help_tags<cr>", { desc = "[T]elescope [H]elp" })
vim.api.nvim_set_keymap("n", prefix.."k", "<cmd>Telescope keymaps<cr>", { desc = "[T]elescope [K]eymaps" })
vim.api.nvim_set_keymap("n", prefix.."r", "<cmd>Telescope registers<cr>", { desc = "[T]elescope [R]egisters" })
vim.api.nvim_set_keymap("n", prefix.."s", "<cmd>Telescope spell_suggest<cr>", { desc = "[T]elescope [S]pell" })

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
