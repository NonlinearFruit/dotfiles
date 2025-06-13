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
  | append nu
  | sort
  | uniq
  | input list --fuzzy
}

def select-tool [] {
  let tools = open tools/tools.yml
  let package = $tools
  | each { $"($in.cmd): ($in.description)" }
  | sort
  | input list --fuzzy
  | parse "{cmd}: {description}"
  | get 0.cmd

  $tools
  | where cmd == $package
  | first
}

def run [manager command parameter] {
  nu -c $'use tools/($manager).nu; ($manager) ($command) ($parameter)'
}
