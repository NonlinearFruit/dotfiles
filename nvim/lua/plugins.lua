-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Interact with tmux in vim
  use 'preservim/vimux'

  -- Neovim in the browser
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }
end)
