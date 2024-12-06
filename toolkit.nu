def --wrapped main [...rest] {
  nu -c $'use toolkit.nu; toolkit ($rest | str join " ")'
}

export def install-nushell [version = latest] {
  if not (is-admin) {
    print "Needs admin rights to install!"
    exit 1
  }
  print $"Old nushell version: ($env.NU_VERSION)"

  get-asset-metadata $version
  | each {|asset|
    let tar_file = download-tarball $asset.browser_download_url
    extract-tarball $tar_file
    let folder = $asset.name | parse '{name}.tar.{type}' | get 0.name
    put-nushell-on-path $folder
  }
  null
}

def get-asset-metadata [version] {
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
  | where name =~ x86_64
  | where name =~ linux
  | where name =~ gnu
  | first
}

def download-tarball [url] {
  let tar_file = "nushell.tar.gz"
  http get $url
  | save -f $tar_file
  print "  Saved tarball"
  $tar_file
}

def extract-tarball [tarball] {
  ^tar xf $tarball --directory=.
  | complete
  | get exit_code
  | if $in != 0 {
    print $"  Extraction failed: `tar xf ($tarball) --directory=.`"
    exit $in
  }
  rm $tarball
  print "  Extracted files"
}

def put-nushell-on-path [folder] {
  let bin_directory = "/usr/local/bin"
  ^mv $"($folder)/nu" $bin_directory
  | complete
  | get exit_code
  | if $in != 0 {
    print $"  Moving binary failed: `mv ($folder)/nu ($bin_directory)`"
    exit $in
  }
  rm -rf $folder
  print $"Installed nushell version: (^$'($bin_directory)/nu' -v)"
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

## Features

<details><summary>Configs</summary>

The actual dotfiles for various tools

(get-configs | each { { Config: $in } } | to md)
</details>

<details><summary>Scripts</summary>

Helpful automation for various tasks

(get-scripts | each { { Script: $in } } | to md)
</details>

<details><summary>Setups</summary>

Automation for initializing a fresh OS

(get-setups | each { { Setup: $in } } | to md)
</details>

<details><summary>Mappings</summary>

Symlink any config file to any location

(get-mappings | each { { Mapping: $in } } | to md)
</details>

<details><summary>Cheatsheets</summary>

Custom TLDR pages

(get-cheatsheets | each { { Cheatsheet: $in } } | to md)
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
'
  | save -f README.md
}

def get-configs [] {
  let not_configs = [
    README, toolkit
    cheatsheets, scripts
    init, setups
    map, mappings
  ]
  ls
  | get name
  | path parse
  | where stem not-in $not_configs
  | get stem
  | uniq
  | sort
}

def get-scripts [] {
  ls scripts
  | get name
  | path parse
  | where ($it.extension | is-empty)
  | get stem
  | sort
}

def get-mappings [] {
  ls mappings
  | get name
  | path parse
  | get stem
  | sort
}

def get-setups [] {
  ls setups
  | get name
  | path parse
  | get stem
  | sort
}

def get-cheatsheets [] {
  ls cheatsheets
  | get name
  | path parse
  | get stem
  | sort
}

export def format [] {
  ^~/.local/share/nvim/mason/bin/stylua --verify . # Lua
}
