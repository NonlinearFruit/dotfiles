#!/usr/bin/env sh

# Run this after cloning, then run `./gap.sh | sh` to link/cp out the configs

# Gap
sudo apt install -y jq

# Vim
mkdir -p ~/.vim/swapfiles
mkdir -p ~/.vim/undofiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir -p ~/.nvim/swapfiles
mkdir -p ~/.nvim/undofiles
mkdir -p ~/.config/nvim

# Scripts
mkdir ~/scripts
