#!/usr/bin/env nu

def --wrapped main [...rest] {
  const pathToSelf = path self
  let nameOfSelf = $pathToSelf | path parse | get stem
  if $rest in [ [-h] [--help] ] {
    nu -c $'use ($pathToSelf); scope modules | where name == ($nameOfSelf) | get 0.commands.name'
  } else {
    nu -c $'use ($pathToSelf); ($nameOfSelf) ($rest | str join (" "))'
  }
}

export def install-manager [manager = ""] {
  let mng = if $manager == "" { select-manager } else { $manager }
  let version = run $mng "self latest-version" ""
  run $mng "self install" $version
}

export def install-tool [tool = ""] {
  let tool = if $tool == "" {
    select-tool
  } else {
    load-tools
    | where cmd == $tool
    | first
  }

  $tool.id?
  | default $tool.cmd
  | run $tool.manager install $in
}

export def list-tools [] {
  load-tools
  | par-each {|tool|
    merge { version: (installed-tool-version $tool) }
  }
  | select cmd version description
  | sort-by cmd
}

def select-manager [] {
  open tools/tools.yml
  | get manager
  | append nu
  | sort
  | uniq
  | input list --fuzzy
}

def installed-tool-version [tool] {
  $tool.id?
  | default $tool.cmd
  | run $tool.manager installed-version $in
  | complete
  | if $in.exit_code != 0 {
    "err"
  } else {
    $in.stdout
  }
}

def select-tool [] {
  let tools = load-tools
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

def load-tools [] {
  open tools/tools.yml
}

def run [manager command parameter] {
  nu -c $'use tools/($manager).nu; ($manager) ($command) ($parameter)'
}
