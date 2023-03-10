#!/usr/bin/env sh

# Run this with `./init.sh | sh` after cloning, then run `./gap.sh | sh` to link/cp out the configs

setup_to_run="setups/$1.sh"
default_setup="setups/common.sh"

if [ -f "$default_setup" ]; then
  cat $default_setup
fi

if [ -f "$setup_to_run" ]; then
  cat $setup_to_run
fi
