export def latest-version [package] {
}

export def installed-version [package] {
  ^dnf info $package
  | complete
  | get stdout
  | lines
  | where $it =~ Version
  | parse '{_}: {version}'
  | get version
  | first
}

export def install [package] {
  if not (is-admin) {
    print "Needs admin rights to install!"
    exit 1
  }
  ^dnf install -y $package
}

export def "self install" [version = latest] {
}

export def "self installed-version" [] {
  ^dnf --version
  | lines
  | parse "{_} version {version}"
  | get version
  | first
}

export def "self latest-version" [] {
}
