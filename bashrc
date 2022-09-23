#!/bin/bash
# Executed by bash(1) for non-login shells.

# Exit if this shell should not be interative
case $- in
    *i*) ;;
      *) return;;
esac

# If no tmux sessions, make a new. Otherwise make a new one (targetting the old) with a new window in the currect directory
if command -v tmux > /dev/null && [ -z "$TMUX" ]; then
  tmux ls 2> /dev/null > /dev/null && tmux new -t $(tmux ls -F '#{session_id}' | sed 's/\$//' | head -1)\; new-window -c "$(pwd)" || tmux
fi

# Update window size after each command
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# History
HISTCONTROL=ignoreboth # No dups and ignore space-first commands
shopt -s histappend # Append history
HISTSIZE=100000 # Store 100k commands in history
HISTFILESIZE=-1 # Ignore history file size

# Prompt
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \033[1;36m$(git prompt)\033[0m\n \$ '

# Autocomplete
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Editor
if command -v vim > /dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# Ellipsis
if [ -d ~/.ellipsis/bin ]; then
    export ELLIPSIS_PREFIX="dot"
    export ELLIPSIS_USER="NonlinearFruit"
    export PATH=$PATH:~/.ellipsis/bin
fi

# Scripts
if [ -d ~/scripts ]; then
    export PATH=$PATH:~/scripts
fi

# Private Configuration (Not source controlled)
if [ -f ~/.bashrc_private ]; then
    source ~/.bashrc_private
fi

# Aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# Jump
if [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh
fi

# SSH
if [ -d ~/.ssh ]; then
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/id_rsa 2> /dev/null
fi

# Pip
if [ -d ~/.local/bin ]; then
    export PATH=$PATH:~/.local/bin
fi

# Sdkman
if [ -d ~/.sdkman ]; then
    export SDKMAN_DIR="/home/bbolen/.sdkman"
    [[ -s "/home/bbolen/.sdkman/bin/sdkman-init.sh" ]] && source "/home/bbolen/.sdkman/bin/sdkman-init.sh"
fi

# Rust
if [ -d ~/.cargo/env ]; then
    source ~/.cargo/env
fi

# Go
if [ -d /usr/local/go/bin ]; then
    export PATH=$PATH:/usr/local/go/bin
fi
