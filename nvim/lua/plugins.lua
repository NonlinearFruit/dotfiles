return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Interact with tmux in vim
  if vim.fn.executable('tmux') == 1 then
    use 'preservim/vimux'
  end

  -- Manager for:
    -- Language Server Protocol (LSP) implementations,
    -- Debug Adapter Protocol (DAP) implementations,
    -- Linters and
    -- Formatters
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig", -- Configure LSPs
    --"nvim-dap", -- Configure DAPs
    "jose-elias-alvarez/null-ls.nvim", -- Configure Linters and Formatters
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }

  -- Neovim in the browser
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- C# LSP
  use 'OmniSharp/omnisharp-vim'

  -- Fun CellularAutomaton make_it_rain && game_of_life
  use 'eandrju/cellular-automaton.nvim'

  -- To support CellularAutomaton
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Game for practicing vim
  use 'ThePrimeagen/vim-be-good'

  -- Telescope for searching things
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

end)
