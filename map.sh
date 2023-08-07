#!/usr/bin/env sh

mapping_to_apply="mappings/$1.json"
default_mapping="mappings/common.json"
json_to_symlink='.[] | if .[2] == "cp" then "cp -r \(.[0]) \(.[1])" elif .[2] == "curl" then "curl \(.[0]) -so \(.[1])" else "ln -sf $(pwd)/\(.[0]) \(.[1])" end'

if [ -f "$default_mapping" ]; then
  jq "$json_to_symlink" --raw-output $default_mapping
fi

if [ -f "$mapping_to_apply" ]; then
  jq "$json_to_symlink" --raw-output $mapping_to_apply
fi
