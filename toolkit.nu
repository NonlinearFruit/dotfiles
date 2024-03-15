export def install-nushell [version = latest] {
  if not (is-admin) {
    print "Needs admin rights to install!"
    return
  }
  print $"Old nushell version: ($env.NU_VERSION)"

  let tar_file = "nushell.tar.gz"
  let bin_directory = "/usr/local/bin"
  let url_ending = if $version == latest {
    $version
  } else {
    $"tags/($version)"
  }

  {
    Accept: "application/vnd.github+json"
    X-GitHub-Api-Version: "2022-11-28"
  }
  | http get -H $in $"https://api.github.com/repos/nushell/nushell/releases/($url_ending)"
  | get assets_url
  | http get $in
  | where name =~ 'x86_64-linux-gnu-full'
  | first
  | each {|asset|
    $asset
    | get browser_download_url
    | http get $in
    | save -f $tar_file
    tar xf $tar_file --directory=.
    let folder = $asset.name | parse '{name}.tar.{type}' | get 0.name
    mv $"($folder)/nu" $bin_directory
    rm $tar_file
    rm -rf $folder
  }
  print $"Installed nushell version: (^$'($bin_directory)/nu' -v)"
}

export def install-go [version = 1.22.0] {
  if not (is-admin) {
    print "Needs admin rights to install!"
    return
  }
  print $"Old go version: (^/usr/local/go/bin/go version | parse 'go version go{version} {os}' | get 0.version)"
  let file = $"go($version).linux-amd64.tar.gz"
  http get $"https://dl.google.com/go/($file)" | save -f $file
  rm -rf /usr/local/go 
  tar -C /usr/local -xzf $file
  rm $file
  print $"Installed go version: (^/usr/local/go/bin/go version | parse 'go version go{version} {os}' | get 0.version)"
}

export def update-readme [] {
$'
<p align="center">
  <img src=".icon.png" alt="dotfiles icon" width="400" height="400"/>
</p>

# Dotfiles

<img alt="GitHub workflow status" src="https://img.shields.io/github/actions/workflow/status/NonlinearFruit/dotfiles/ci.yml">

A simple repo that elegantly manages my configs and scripts using `init.sh` and `map.sh`

## Setup on fresh OS

Might need to `sudo apt update && sudo apt upgrade` if some dependencies can not install

```sh
sudo apt update
sudo apt install -y git
git clone https://github.com/NonlinearFruit/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
./init.sh common | sh
./map.sh common | sh
```

### OS Specific Setup and Mappings

For configuration specific to a particular OS, create setup and mappings for it. For instance, if you have a `setups/termux.sh` and a `mappings/wsl.json`, then you can:
```sh
./init.sh common termux | sh
./map.sh common wsl | sh
```

## Configs

| Config                  | Description                                  |
| ---                     | ---                                          |
| `bash-aliases.sh`       |                                              |
| `bashrc.sh`             | [Bash][bash]                                 |
| `cheatsheets/`          | [TLDR][tldr] extensions                      |
| `gitconfig.ini`         | [Git][git]                                   |
| `glaze-wm.yaml`         | [Glaze Window Manager][glaze]                |
| `mappings/`             | Available mappings                           |
| `nvim/`                 | [Neovim][nvim]                               |
| `scripts/`              | Helpful scripts                              |
| `setups/`               | Available setups                             |
| `tmux.conf`             | [Tmux][tmux]                                 |
| `vimrc.vim`             | [Vim][vim] + [IdeaVim][ideavim]              |
| `vivaldi/`              | [Vivaldi mods][vivaldi-mods]                 |
| `vivaldi.html`          | [Vivaldi][vivaldi]                           |
| `wezterm/`              | [Wezterm][wezterm]                           |
| `windows-terminal.json` | [Windows Terminal][windowsterminal]          |

[bash]: https://savannah.gnu.org/projects/bash/
[git]: https://git-scm.com/docs
[glaze]: https://github.com/lars-berger/GlazeWM/releases
[ideavim]: https://github.com/JetBrains/ideavim
[nvim]: https://github.com/neovim/neovim
[tldr]: https://github.com/dbrgn/tealdeer
[tmux]: https://github.com/tmux/tmux
[vim]: https://github.com/vim/vim
[vivaldi]: https://vivaldi.com
[vivaldi-mods]: https://forum.vivaldi.net/category/52/modifications
[wezterm]: https://github.com/wez/wezterm
[windowsterminal]: https://github.com/microsoft/terminal

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
| highlight            | Highlights matches to the given regex                |
| ipsum                | Random word generator                                |
| look-alike           | Find words within edit distance 2 of the given word  |
| number-gossip        | Show special properties of the given number          |
| passphrase           | Generates a password of the form `Word#Word#Word`    |
| rusty-link           | Symlink rust binary to ~/scripts folder              |
| stopwatch            | Indefinite timer                                     |
| sundays              | Number of Sundays until given birthdate turns 18     |

## Formatting

```sh
~/.local/share/nvim/mason/bin/stylua --verify . # Lua
```

## Restarting

- Throw away current nvim config
    ```sh
    rm ~/{.local/share,.config}/nvim/* -rf
    ```
'
  | save -f README.md
}
