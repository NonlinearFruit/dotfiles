#!/usr/bin/env sh

# Run this after cloning, then run `./gap.sh | sh` to link/cp out the configs

# Vim
mkdir ~/.vim
mkdir ~/.vim/swapfiles
mkdir ~/.vim/undofiles
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
mkdir ~/.config/nvim

# Scripts
mkdir ~/scripts
curl https://raw.githubusercontent.com/NonlinearFruit/english-words/master/words.txt > $ELLIPSIS_HOME/scripts/words.txt
