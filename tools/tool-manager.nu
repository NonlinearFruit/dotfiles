#!/usr/bin/env nu

export def main --wrapped [...args] {
  let tool = if ($args | is-empty) {
    select-tool
  } else {
    load-tools
    | where cmd == $args.0
    | first
  }

  $tool.id?
  | default $tool.cmd
  | ^$tool.manager install -y $in
}

def select-tool [] {
  load-tools
  | sort-by cmd
  | input list --fuzzy --display { $"($in.cmd): ($in.description)" }
}

def load-tools [] {
  open tools/tools.yml
}
