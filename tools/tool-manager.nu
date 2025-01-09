#!/usr/bin/env nu

export def install-manager [] {
  let manager = select-manager
  let version = run $manager "self latest-version" ""
  run $manager "self install" $version
}

export def install-tool [] {
  let tool = select-tool

  $tool.id?
  | default $tool.cmd
  | run $tool.manager install $in
}

def select-manager [] {
  open tools/tools.yml
  | get manager
  | uniq
  | input list --fuzzy
}

def select-tool [] {
  let tools = open tools/tools.yml
  let package = $tools
  | each { $"($in.cmd): ($in.description)" }
  | input list --fuzzy
  | parse "{cmd}: {description}"
  | get 0.cmd

  $tools
  | where cmd == $package
  | first
}

def run [manager command parameter] {
  let alias = match $manager {
    cargo => { "bargo" },
    go => { "bo" },
    dotnet => { "botnet" }
  }
  nu -c $'use tools/($alias).nu; ($alias) ($command) ($parameter)'
}
