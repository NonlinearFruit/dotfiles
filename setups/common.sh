#!/usr/bin/env sh

# Install Nerd Font? (https://www.nerdfonts.com/font-downloads)

# Gap
MANAGER=apt
if command -v dnf > /dev/null; then
  MANAGER=dnf
fi
sudo $MANAGER install -y jq curl
mkdir -p ~/projects/privatefiles

# Neovim
mkdir -p ~/.config/nvim

# Scripts
mkdir -p ~/scripts

# Git Jump
curl https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/git-jump/git-jump -o ~/scripts/git-jump
chmod +x ~/scripts/git-jump

# Tealdear
mkdir -p ~/.local/share/tealdeer/pages

# Wezterm
mkdir -p ~/.config/wezterm/

# Mise
mkdir -p ~/.config/mise/

# Keys
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""

# Nushell
mkdir -p ~/.config/nushell/scripts

# Glide
mkdir -p ~/.config/glide/

# Pi
mkdir -p ~/.pi/agent/{extensions,skills,prompts}/

# Nono
mkdir -p ~/.config/nono/profiles/
