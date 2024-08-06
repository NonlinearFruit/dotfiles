#!/bin/bash

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias populars='history | sed -E "s/^[ ]+[0-9]+[ ]+//" | cut -d" " -f1 | sort | uniq -c --repeated | sort -r'
alias tmux-clean='tmux ls -F "#{session_attached} #{session_group} #{session_id}" | grep ^0 | sed "s/^0 //" | sed "s/ [$]/-/" | xargs -I % tmux kill-session -t %'
alias tmux-join='tmux ls 2> /dev/null > /dev/null && tmux new -t $(tmux ls -F "#{session_id}" | sed "s/\$//" | head -1)\; new-window -c "$(pwd)" || tmux'
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
