export def latest-version [package] {
}

export def installed-version [package] {
}

export def install [package] {
}

export def "self install" [version = 1.22.0] {
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

export def "self installed-version" [] {
}

export def "self latest-version" [] {
}
