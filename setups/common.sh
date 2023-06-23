#!/usr/bin/env sh

# Install Nerd Font? (https://www.nerdfonts.com/font-downloads)

# Gap
sudo apt install -y jq curl

# Vim
mkdir -p ~/.vim/swapfiles
mkdir -p ~/.vim/undofiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim
sudo apt install -y build-essential # for Telescope FZF extension
mkdir -p ~/.nvim/swapfiles
mkdir -p ~/.nvim/undofiles
mkdir -p ~/.config/nvim

# Scripts
mkdir ~/scripts
