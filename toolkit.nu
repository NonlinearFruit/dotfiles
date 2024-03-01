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
  | where name =~ 'x86_64-linux-gnu-full'
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
  print $"Old go version: (^/usr/local/go/bin/go version | parse 'go version go{version} {os}' | get 0.version)"
  let file = $"go($version).linux-amd64.tar.gz"
  http get $"https://dl.google.com/go/($file)" | save -f $file
  rm -rf /usr/local/go 
  tar -C /usr/local -xzf $file
  rm $file
  print $"Installed go version: (^/usr/local/go/bin/go version | parse 'go version go{version} {os}' | get 0.version)"
}
