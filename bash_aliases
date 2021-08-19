#!/bin/bash

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotnet='dotnet.exe'
alias paste.exe="powershell.exe Get-Clipboard"
alias populars='history | sed -E "s/^[ ]+[0-9]+[ ]+//" | cut -d" " -f1 | sort | uniq -c --repeated | sort -r'
alias rider='/mnt/c/Program\ Files/JetBrains/JetBrains\ Rider\ 2019.1.2/bin/rider64.exe'
alias smi='/mnt/c/Projects/Dotnet.Smi/Dotnet.Smi/bin/Debug/net5.0/Dotnet.Smi.exe'
alias youtube-dl-audio='youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
alias tmux-join='tmux ls 2> /dev/null > /dev/null && tmux new -t $(tmux ls -F "#{session_id}" | sed "s/\$//" | head -1)\; new-window -c "$(pwd)" || tmux'
alias tmux-clean='tmux ls -F "#{session_attached} #{session_group} #{session_id}" | grep ^0 | sed "s/^0 //" | sed "s/ [$]/-/" | xargs -I % tmux kill-session -t %'
