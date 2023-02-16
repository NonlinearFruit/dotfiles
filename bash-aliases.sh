#!/bin/bash

alias copy="clip.exe"
alias dotnet='dotnet.exe'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias paste="powershell.exe Get-Clipboard"
alias podman="podman.exe"
alias populars='history | sed -E "s/^[ ]+[0-9]+[ ]+//" | cut -d" " -f1 | sort | uniq -c --repeated | sort -r'
alias rider='rider64.exe'
alias tmux-clean='tmux ls -F "#{session_attached} #{session_group} #{session_id}" | grep ^0 | sed "s/^0 //" | sed "s/ [$]/-/" | xargs -I % tmux kill-session -t %'
alias tmux-join='tmux ls 2> /dev/null > /dev/null && tmux new -t $(tmux ls -F "#{session_id}" | sed "s/\$//" | head -1)\; new-window -c "$(pwd)" || tmux'
alias vim="$EDITOR"
alias vlc="\"$(wslpath 'C:\Program Files\VideoLAN\VLC\vlc.exe')\""
alias youtube-dl-audio='youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
