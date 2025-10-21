export def latest-version [package] {
}

export def installed-version [package] {
  ^flatpak info $package
  | lines
  | where $it =~ Version
  | parse '{_}: {version}'
  | get version
  | first
}

export def install [package] {
  # if not (is-admin) {
  #   print "Needs admin rights to install!"
  #   exit 1
  # }
  ^flatpak install -y $package
}

export def "self install" [version = latest] {
}

export def "self installed-version" [] {
  ^flatpak --version
  | parse '{_} {version}'
  | get version
  | first
}

export def "self latest-version" [] {
}
