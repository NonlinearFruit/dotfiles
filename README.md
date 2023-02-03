<p align="center">
  <img src=".icon.png" alt="dotfiles icon" width="400" height="400"/>
</p>

# Dotfiles

A simple repo that elegantly manages my configs and scripts using Git Map (see `gap.sh`)

## Setup on fresh OS

```sh
sudo apt install git jq
mkdir ~/projects
cd ~/projects
git clone https://github.com/NonlinearFruit/dotfiles
cd dotfiles
./init.sh
./gap.sh
```

## Configs

| Config                | Description                                  |
| ---                   | ---                                          |
| bash_aliases          | All the aliases                              |
| bashrc                | Bash settings                                |
| gitconfig             | [Git][git] settings                          |
| ideavimrc             | [IdeaVim][ideavim] settings                  |
| tmux.config           | [Tmux][tmux] settings                        |
| vimrc                 | [Vim][vim] settings                          |
| windows_terminal.json | [Windows][windowsterminal] Terminal settings |

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

[git]: https://git-scm.com/docs
[ideavim]: https://github.com/JetBrains/ideavim
[tmux]: https://github.com/tmux/tmux
[vim]: https://github.com/vim/vim
[windowsterminal]: https://github.com/microsoft/terminal
