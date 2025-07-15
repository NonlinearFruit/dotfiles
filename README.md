
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

## Features

<details><summary>Configs</summary>

The actual dotfiles for various tools

|Config|
|-|
|bash-aliases|
|bashrc|
|firefox|
|gitconfig|
|nvim|
|ollama|
|termux|
|tmux|
|tools|
|vimrc|
|vivaldi|
|wezterm|
|wsl|
</details>

<details><summary>Scripts</summary>

Helpful automation for various tasks

|Script|
|-|
|backup-repo|
|clip|
|countdown|
|datediff|
|esv|
|esv-search|
|highlight|
|ipsum|
|is|
|last-cron|
|llm|
|look-alike|
|mp3|
|ned|
|number-gossip|
|nvim-plugins|
|nvims|
|passphrase|
|precisionvim|
|profile-nvim|
|reprint|
|ssh|
|stopwatch|
|sundays|
|tmux-clients-in-window|
|tmux-clones|
|tmux-rogues|
|to-me|
|to-vimgrep|
|toggle-pair|
|view|
|who-is-smallest-of-them-all|
|whos-where|
</details>

<details><summary>Setups</summary>

Automation for initializing a fresh OS

|Setup|
|-|
|common|
|haskell|
|nvims|
|openscad|
|termux|
|tools|
|wsl|
</details>

<details><summary>Mappings</summary>

Symlink any config file to any location

|Mapping|
|-|
|common|
|termux|
|wsl|
</details>

<details><summary>Cheatsheets</summary>

Custom TLDR pages

|Cheatsheet|
|-|
|bash-notes|
|cargo-watch|
|dbeaver-mongo|
|dotnet-format|
|dotnet-outdated|
|fzf-notes|
|neotest|
|neovim|
|nerd-font-symbols|
|nerd-fonts|
|netrw|
|null-ls|
|nvim-dap|
|podman-notes|
|rust-notes|
|telescope|
|tmux-notes|
|wezterm|
|winget|
|wsl2|
</details>

## Formatting

```sh
~/.local/share/nvim/mason/bin/stylua --verify . # Lua
```

## Restarting

- Throw away current nvim config
    ```sh
    rm ~/{.local/share,.config}/nvim/* -rf
    ```
