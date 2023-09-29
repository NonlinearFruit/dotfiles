# fzf: Fuzzy find stuff
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# dos2unix: converts files from dos and unix and back again
# figlet: ascii font
# tmux: Terminal multiplexing
# jq: json query
# curl: http requests
# unzip: extract zips (required by omnisharp)
# xclip: copy/paste from clipboard
# gcc-c++: c++ compiler (required by treesitter)
# gcc: c compiler (required by rust)
MANAGER=apt
if command -v dnf > /dev/null; then
  MANAGER=dnf
fi
sudo $MANAGER install -y curl figlet jq tmux unzip xclip gcc-c++ gcc g++

# Load cargo into current shell
source ~/.bashrc

# bat: better cat https://github.com/sharkdp/bat
cargo install bat

# bob: nvim version manager https://github.com/MordechaiHadad/bob
cargo install bob-nvim

# fd: better find https://github.com/sharkdp/fd
cargo install fd-find

# fnm: node versioning https://github.com/Schniz/fnm
cargo install fnm

# htmlq: jq for html using css selectors https://github.com/mgdm/htmlq
cargo install htmlq

# ripgrep: better grep https://github.com/BurntSushi/ripgrep
cargo install ripgrep

# tldr: examples of using different commands https://github.com/dbrgn/tealdeer
cargo install tealdeer

# watch: automatically run tests and things when files change `cargo watch -x test`
cargo install cargo-watch

# z: better autojump https://github.com/ajeetdsouza/zoxide
cargo install zoxide

# speedtest-cli: collect up/down network data
# pip install speedtest-cli
# PATH="${PATH}:${HOME}/.local/bin"
# /home/pi/.local/bin/speedtest-cli --csv-header > /home/pi/xfinity_speed.csv
# crontab -e
# */10 * * * * /home/pi/.local/bin/speedtest-cli --csv >> /home/pi/xfinity_speed.csv

# wolfram engine + wolfram script
## https://www.wolfram.com/wolframscript/?source=nav
## activation key how to: https://mathematica.stackexchange.com/a/215202
