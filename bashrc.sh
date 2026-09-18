#!/bin/bash
# Executed by bash(1) for non-login shells.

# https://www.nushell.sh/blog/2026-02-28-nushell_v0_111_0.html#experimental-native-clipboard
export NU_EXPERIMENTAL_OPTIONS=native-clip

# Scripts
if [ -d ~/scripts ]; then
    export PATH="$PATH:$HOME/scripts"
fi

eval "$(~/.local/bin/mise activate bash)"

# Exit if this shell should not be interative
case $- in
    *i*) ;;
      *) return;;
esac

# Terminal multiplexing
if is lonely; then                                       # Pairs should manually decide how to attach/create tmux sessions
  if command -v tmux > /dev/null && [ -z "$TMUX" ]; then # If tmux exists && we're not in a tmux session
    if tmux ls 2> /dev/null > /dev/null; then            # If tmux sessions already exist
      tmux new -t nonlinearfruit \; new-window -c "$(pwd)" # attach
    else
      tmux new -s nonlinearfruit                           # new
    fi
  fi
fi

# Update window size after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# History
HISTCONTROL=ignoreboth # No dups and ignore space-first commands
shopt -s histappend # Append history
HISTSIZE=100000 # Store 100k commands in history
HISTFILESIZE=-1 # Ignore history file size

# Prompt <https://unix.stackexchange.com/a/124409/194972>
restore_color='\[\033[0m\]'
light_cyan='\[\033[01;36m\]'
light_gray='\[\033[00;37m\]'
dark_gray='\[\033[01;30m\]'
machine_context='\u@\h'
machine="${dark_gray}$machine_context${restore_color}"
location_context='\w'
location="${light_gray}$location_context${restore_color}"
if command -v git-prompt > /dev/null; then
  extra_context='$(git prompt)'
fi
extra="${light_cyan}$extra_context${restore_color}"
prompt=' $ '
PS1="\n$machine:$location $extra\n$prompt"

# Autocomplete
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
elif command -v vim > /dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# Private Configuration (Not source controlled)
if [ -f ~/.bashrc_private ]; then
    source ~/.bashrc_private
fi

# User binaries
if [ -d ~/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Fuzzy Find (fzf)
if command -v fzf > /dev/null; then
  eval "$(fzf --bash)"

  # Use fd (rust find)
  if command -v fd > /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# Zoxide
if command -v zoxide > /dev/null; then
  eval "$(zoxide init bash)"
  if is lonely; then
    alias cd='echo -e "use z and try again, n00b" #'
    alias j='echo -e "I like the spunk, but use z instead" #'
  fi
fi

# Remove Windows npm <https://github.com/microsoft/WSL/issues/3882#issuecomment-543833151>
if is wsl ; then
  export PATH="$(echo "$PATH" | sed 's#:/mnt/c/Program Files/nodejs/##g')"
fi

# Aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
