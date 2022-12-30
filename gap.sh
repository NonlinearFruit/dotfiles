#!/usr/bin/env sh

mapping_to_apply="mappings/$1.json"
default_mapping="mappings/common.json"
json_to_symlink='.[] | "ln -f \(.[0]) \(.[1])"'

if [ -f "$default_mapping" ]; then
  jq "$json_to_symlink" --raw-output $default_mapping
fi

if [ -f "$mapping_to_apply" ]; then
  jq "$json_to_symlink" --raw-output $mapping_to_apply
fi
