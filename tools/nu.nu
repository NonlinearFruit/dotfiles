export def latest-version [package] {
}

export def installed-version [package] {
}

export def install [package] {
}

export def "self install" [version = latest] {
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


export def "self installed-version" [] {
}

export def "self latest-version" [] {
}
