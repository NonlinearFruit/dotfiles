export def latest-version [package] {
}

export def installed-version [package] {
  ^dotnet tool list -g $package
  | lines
  | last
  | str replace -r '^\D+(\d+\.\d+\.\d+)\D+$' '$1'
}

export def install [package] {
  ^dotnet tool install -g $package
}

# dotnet <https://learn.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install>
export def "self install" [version = "9.0"] {
  ^wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
  ^chmod +x ./dotnet-install.sh
  ^./dotnet-install.sh --channel $version
  ^rm ./dotnet-install.sh
}

export def "self installed-version" [] {
  ^dotnet --list-sdks
  | lines
  | parse '{version} {end}'
  | last
}

export def "self latest-version" [] {
}
