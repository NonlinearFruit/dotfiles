#!/usr/bin/env sh

# Install Nerd Font? (https://www.nerdfonts.com/font-downloads)

# Gap
MANAGER=apt
if command -v dnf > /dev/null; then
  MANAGER=dnf
fi
sudo $MANAGER install -y jq curl
mkdir -p ~/projects/privatefiles

# Vim
mkdir -p ~/.vim/swapfiles
mkdir -p ~/.vim/undofiles

# Neovim
sudo $MANAGER install -y build-essential # for Telescope FZF extension
mkdir -p ~/.nvim/swapfiles
mkdir -p ~/.nvim/undofiles
mkdir -p ~/.config/nvim

# Scripts
mkdir ~/scripts

# Tealdear
mkdir -p ~/.local/share/tealdeer/pages

# Wezterm
mkdir -p  ~/.config/wezterm/

# Keys
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
