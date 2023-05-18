<p align="center">
  <img src=".icon.png" alt="dotfiles icon" width="400" height="400"/>
</p>

# Dotfiles

A simple repo that elegantly manages my configs and scripts using Git Map (see `gap.sh`)

## Setup on fresh OS

Might need to `sudo apt update && sudo apt upgrade` if some dependencies can't install

```sh
sudo apt install git
git clone https://github.com/NonlinearFruit/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
./init.sh | sh
./gap.sh | sh
```

### OS Specific Setup and Mappings

For configuration specific to a particular OS (or a particular environment), create setup and mappings for it. For instance, if you have a `setups/termux.sh` and a `mappings/wsl.json`, then you can:
```sh
./init.sh termux | sh
./gap.sh wsl | sh
```

> NOTE: The `setups/common.sh` and the `mappings/common.json` are always included (if they exist)

## Configs

| Config                | Description                                  |
| ---                   | ---                                          |
| `bash-aliases.sh` |  |
| `bashrc.sh` | [Bash][bash] |
| `cheatsheets/` | [TLDR][tldr] extensions |
| `gitconfig.ini` | [Git][git |
| `mappings/` | Available mappings |
| `nvim/` | [Neovim][nvim] |
| `scripts/` | Helpful scripts |
| `setups/` | Available setups |
| `tmux.conf` | [Tmux][tmux] |
| `vimrc.vim` | [Vim][vim] + [IdeaVim][ideavim] |
| `vivaldi/` | [Vivaldi mods][vivaldi-mods] |
| `vivaldi.html` | [Vivaldi][vivaldi] |
| `wezterm/` | [Wezterm][wezterm] |
| `windows-terminal.json` | [Windows Terminal][windowsterminal] |

## Scripts

| Script               | Description                                          |
| ---                  | ---                                                  |
| checkup              | Show status of given git folder                      |
| checkup-personal     | Show status of wiki, notes, ellipsis and junk        |
| checkup-rust         | Show status of all rust projects                     |
| checkup-work         | Show status of work projects                         |
| checkup-retrospector | Show status of retrospector projects                 |
| checkup-fun          | Show status of fun projects                          |
| countdown            | Timer                                                |
| datediff             | # of days to past date                               |
| esv                  | Bible lookup tool                                    |
| esv-search           | Bible search tool                                    |
| highlight            | Highlights matches to the given regex (no filtering) |
| ipsum                | Random word generator                                |
| look-alike           | Find words within edit distance 2 of the given word  |
| number-gossip        | Show special properties of the given number          |
| passphrase           | Generates a password of the form `Word#Word#Word`    |
| rusty-link           | Symlink rust binary to ~/scripts folder              |
| stopwatch            | Indefinite timer                                     |
| sundays              | Number of Sundays until given birthdate turns 18     |
| tomato               | 25 minute timer                                      |
| tomato-break         | Choose tomato spacing                                |
| tomato-do            | 25 minute tmux session                               |
| tomato-done          | End tmux tomato                                      |

[bash]: https://savannah.gnu.org/projects/bash/
[git]: https://git-scm.com/docs
[ideavim]: https://github.com/JetBrains/ideavim
[nvim]: https://github.com/neovim/neovim
[tldr]: https://github.com/dbrgn/tealdeer
[tmux]: https://github.com/tmux/tmux
[vim]: https://github.com/vim/vim
[vivaldi]: https://vivaldi.com
[vivaldi-mods]: https://forum.vivaldi.net/category/52/modifications
[wezterm]: https://github.com/wez/wezterm
[windowsterminal]: https://github.com/microsoft/terminal
