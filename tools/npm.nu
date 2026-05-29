export def latest-version [package] {
}

export def installed-version [package] {
}

export def install [package] {
  ^npm install --global $package
}

export def "self install" [version] {
}

export def "self installed-version" [] {
}

export def "self latest-version" [] {
}
