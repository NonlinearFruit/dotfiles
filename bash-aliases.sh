#!/bin/bash

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias populars='history | sed -E "s/^[ ]+[0-9]+[ ]+//" | cut -d" " -f1 | sort | uniq -c --repeated | sort -r'
alias vi="$EDITOR"
alias vim="$EDITOR"
alias protontricks='flatpak run com.github.Matoking.protontricks'

if is wsl ; then
  alias npp='notepad++.exe'
  alias podman="podman.exe"
  if ! command -v dotnet > /dev/null ; then
    alias dotnet='dotnet.exe'
  fi
fi
