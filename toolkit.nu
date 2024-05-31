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
  | where name =~ x86_64
  | where name =~ linux
  | where name =~ gnu
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
  if ("/usr/local/go/bin/go" | path exists) {
    print $"Old go version: (^/usr/local/go/bin/go version | parse 'go version go{version} {os}' | get 0.version)"
  }
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
}

def get-scripts [] {
  ls scripts
  | get name
  | path parse
  | where ($it.extension | is-empty)
  | get stem
}

def get-mappings [] {
  ls mappings
  | get name
  | path parse
  | get stem
}

def get-setups [] {
  ls setups
  | get name
  | path parse
  | get stem
}

def get-cheatsheets [] {
  ls cheatsheets
  | get name
  | path parse
  | get stem
}
