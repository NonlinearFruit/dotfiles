#!/usr/bin/env sh

# Run this with `./init.sh common | sh` after cloning, then run `./gap.sh | sh` to link/cp out the configs
for name in "$@"; do
  file="setups/${name}.sh"
  if [ -f "$file" ]; then
    cat $file
  fi
done
