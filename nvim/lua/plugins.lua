local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

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
    "williamboman/mason.nvim", -- Tool to install LSP/DAP/linter/formatters
    "williamboman/mason-lspconfig.nvim", -- Easier to configure mason
    "neovim/nvim-lspconfig", -- Configure LSPs
    "jose-elias-alvarez/null-ls.nvim", -- Configure Linters and Formatters
    run = ":MasonUpdate" -- :MasonUpdate updates registry contents
  }
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} } -- Configure DAPs
  -- C# LSP with extra sugar
  use 'Hoffs/omnisharp-extended-lsp.nvim'

  -- Neovim in the browser
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- Good syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Telescope for searching things
  use {
    'nvim-telescope/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' }
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  -- Basic git tooling
  use 'lewis6991/gitsigns.nvim'

  -- Viewing diffs and conflicts
  use "sindrets/diffview.nvim"

  -- Autocomplete and Snippets
  use 'hrsh7th/nvim-cmp' -- ??
  use 'hrsh7th/cmp-nvim-lsp' -- get completions from lsp
  use 'L3MON4D3/LuaSnip' -- snippet engine

  -- jq play
  use 'phelipetls/vim-jqplay'

  -- Commenting
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Dashboard
  use {
    'glepnir/dashboard-nvim',
    config = function()
      require('my-dashboard')
    end,
    requires = {'nvim-tree/nvim-web-devicons'}
  }

  -- Running tests
  use({
    "nvim-neotest/neotest",
    requires = {
      {
        "Issafalcon/neotest-dotnet",
      },
    }
  })

  -- Fun CellularAutomaton make_it_rain && game_of_life
  use {
    'eandrju/cellular-automaton.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' }
  }

  -- Game for practicing vim
  use 'ThePrimeagen/vim-be-good'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
