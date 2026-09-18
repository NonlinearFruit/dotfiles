#!/usr/bin/env sh

for name in "$@"; do
  file="setups/${name}.sh"
  if [ -f "$file" ]; then
    cat $file
  fi
done
