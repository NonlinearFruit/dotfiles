#!/usr/bin/env sh

# Install Nerd Font? (https://www.nerdfonts.com/font-downloads)

# Gap
MANAGER=apt
if command -v dnf > /dev/null; then
  MANAGER=dnf
fi
sudo $MANAGER install -y jq curl
mkdir -p ~/scripts ~/.local/share/applications ~/.local/share/icons/hicolor/48x48/apps

# Git Jump
curl https://raw.githubusercontent.com/git/git/refs/heads/master/contrib/git-jump/git-jump -o ~/scripts/git-jump
chmod +x ~/scripts/git-jump

curl https://raw.githubusercontent.com/NonlinearFruit/Creeds.json/master/creeds/westminster_shorter_catechism.json -o ~/scripts/westminster_shorter_catechism.json
curl https://raw.githubusercontent.com/NonlinearFruit/english-words/master/words.txt -o ~/scripts/words.txt
curl https://raw.githubusercontent.com/neovim/neovim/refs/heads/master/runtime/nvim.desktop -o ~/.local/share/applications/nvim.desktop
curl https://raw.githubusercontent.com/neovim/neovim/refs/heads/master/runtime/nvim.png -o ~/.local/share/icons/hicolor/48x48/apps/nvim.png

# Keys
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
