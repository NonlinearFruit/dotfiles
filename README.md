
<p align="center">
  <img src=".icon.png" alt="dotfiles icon" width="400" height="400"/>
</p>

# Dotfiles

<img alt="GitHub workflow status" src="https://img.shields.io/github/actions/workflow/status/NonlinearFruit/dotfiles/ci.yml">

A simple repo that elegantly manages my configs and scripts using `init.sh` and `mise`

## Setup on fresh OS

```sh
sudo dnf update -y
curl -fsSL https://mise.run/bash | sh
sudo dnf install -y git
git clone https://github.com/NonlinearFruit/dotfiles ~/projects/dotfiles
cd ~/projects/dotfiles
./init.sh common | sh
mise dot apply --yes
nvim
```

### OS Specific Setup and Mappings

For configuration specific to a particular OS, create setup and mappings for it. For instance, if you have a `setups/termux.sh`, then you can:
```sh
./init.sh common termux | sh
mise dot apply --yes
mise --env termux dot apply --yes
```

## Features

<details><summary>Configs</summary>

The actual dotfiles for various tools

| Config |
| --- |
| bash-aliases |
| bashrc |
| gitconfig |
| glide |
| mise |
| mise-global |
| nono |
| nvim |
| pi |
| termux |
| tmux |
| tools |
| vimrc |
| wezterm |
| wsl-etc |
| wsl-windows |
</details>

<details><summary>Scripts</summary>

Helpful automation for various tasks

| Script | Demo |
| --- | --- |
| -- | [demo](.tapes/--.gif) |
| backup-repo |  |
| chat |  |
| clean-history |  |
| clip |  |
| cljue | [demo](.tapes/cljue.gif) |
| countdown |  |
| datediff |  |
| esv | [demo](.tapes/esv.gif) |
| esv-search |  |
| gdocs |  |
| git-prompt |  |
| highlight | [demo](.tapes/highlight.gif) |
| ipsum |  |
| is |  |
| is-revert |  |
| last-cron |  |
| look-alike |  |
| lsb | [demo](.tapes/lsb.gif) |
| matthew-henry-gate | [demo](.tapes/matthew-henry-gate.gif) |
| mob |  |
| mp3 |  |
| ned | [demo](.tapes/ned.gif) |
| number-gossip |  |
| nvim-list-servers |  |
| nvim-plugins |  |
| nvims |  |
| open |  |
| open-nvim-from-windows |  |
| passphrase |  |
| profile-nvim | [demo](.tapes/profile-nvim.gif) |
| reprint |  |
| ssh |  |
| stopwatch |  |
| sundays |  |
| tmux-clients-in-window |  |
| tmux-clones |  |
| tmux-rogues |  |
| to-me |  |
| to-vimgrep |  |
| toggle-pair |  |
| vdocs |  |
| who-is-smallest-of-them-all |  |
| whos-where |  |
</details>

<details><summary>Setups</summary>

Automation for initializing a fresh OS

| Setup |
| --- |
| common |
| haskell |
| nvims |
| openscad |
| termux |
| tools |
| wsl |
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
