export def latest-version [package] {
  ^cargo search --limit 1 $package
  | complete
  | if $in.exit_code == 0 {
    get stdout
    | parse '{id} = "{version}"{space}# {description}'
    | where id == $package
    | get --optional version.0
  }
}

export def installed-version [package] {
  ^cargo install --list
  | parse '{id} v{version}:'
  | where id == $package
  | get --optional version.0
}

export def install [package] {
  ^cargo install --locked $package
}

export def "self install" [version] {
  if (which "rustup" | is-empty) {
    ^curl https://sh.rustup.rs -sSf | sh -s -- -y
    # dnf install gcc
  } else {
    ^rustup update stable
  }
}

export def "self installed-version" [] {
  ^rustup --version
  | complete
  | get stdout
  | parse 'rustup {version} {end}'
  | get --optional version.0
}

export def "self latest-version" [] {
  which rustup
  | if ($in | is-empty) {
    0
  } else {
    ^rustup check
    | complete
    | get stdout
    | lines
    | parse "rustup - {msg} : {version}"
    | get version
    | str replace '^.*(\d+\.\d+\.\d+)$' '$1'
    | first
  }
}
