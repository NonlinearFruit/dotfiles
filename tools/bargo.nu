export def latest-version [package] {
  ^cargo search --limit 1 $package
  | complete
  | if $in.exit_code == 0 {
    get stdout
    | parse '{id} = "{version}"{space}# {description}'
    | where id == $package
    | get -i version.0
  }
}

export def installed-version [package] {
  ^cargo install --list
  | parse '{id} v{version}:'
  | where id == $package
  | get -i version.0
}

export def install [package] {
  ^cargo install $package
}

export def "self install" [version] {
  ^curl https://sh.rustup.rs -sSf | sh -s -- -y
  # rustup update stable
}

export def "self installed-version" [] {
  ^cargo --version
  | parse 'cargo {version} {end}'
  | get -i version.0
}

export def "self latest-version" [] {
  ^rustup check
}
