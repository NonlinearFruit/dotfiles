<p align="center">
  <img src=".icon.png" alt="dotfiles icon" width="400" height="400"/>
</p>

# Dotfiles

A simple ellipsis package that elegantly manages my configs and scripts.

## Setup on fresh OS

- `sudo apt install git`
- `curl https://ellipsis.sh | sh`
- `~/.ellipsis/bin/ellipsis install https://github.com/NonlinearFruit/dotfiles`

## Configs

| Config                | Description                                  |
| ---                   | ---                                          |
| bash_aliases          | All the aliases                              |
| bashrc                | Bash settings                                |
| dijo.toml             | [Dijo][dijo] settings                        |
| gitconfig             | [Git][git] settings                          |
| ideavimrc             | [IdeaVim][ideavim] settings                  |
| newsboat/*            | [Newsboat][newsboat] settings                |
| tmux.config           | [Tmux][tmux] settings                        |
| vimrc                 | [Vim][vim] settings                          |
| windows_terminal.json | [Windows][windowsterminal] Terminal settings |

## Manual Configs

These are found in the `manual` directory and, as the name suggests, the symlinks need to be configured manually with a command like this:
```
ln -s ~/.ellipsis/packages/files/manual/$FILE /mnt/c/$DESTINATION
```

| Config                | Path                                                                                                                 |
| ---                   | ---                                                                                                                  |
| windows_terminal.json | `/mnt/c/Users/bbolen/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json` |
| ideavimrc             | `/mnt/c/Users/bbolen/.ideavimrc`                                                                                     |
| dijo.toml             | `~/.config/dijo/config.toml`                                                                                         |

## Directories

| Directory | Description                             |
| ---       | ---                                     |
| manual    | Configs that need to be manually linked |
| newsboat  | Newsboat settings                       |
| scripts   | Bash scripts                            |

## Programs

| Program  | Description             |
| ---      | ---                     |
| Vim Plug | Package manager for vim |

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

[dijo]: https://github.com/NerdyPepper/dijo
[git]: https://git-scm.com/docs
[ideavim]: https://github.com/JetBrains/ideavim
[newsboat]: https://github.com/newsboat/newsboat
[tmux]: https://github.com/tmux/tmux
[vim]: https://github.com/vim/vim
[windowsterminal]: https://github.com/microsoft/terminal
