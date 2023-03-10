#!/usr/bin/env sh

# Update everything
pkg update
pkg upgrade

# Add basic necessities
pkg install jq
pkg install termux-api
pkg install neovim
pkg install openssh
pkg install tealdeer
