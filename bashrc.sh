#!/bin/bash
# Executed by bash(1) for non-login shells.

# Scripts
if [ -d ~/scripts ]; then
    export PATH=$PATH:~/scripts
fi

# Exit if this shell should not be interative
case $- in
    *i*) ;;
      *) return;;
esac

# Exit if Rider 2024.3 opened the shell
if is rider; then
  return
fi

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
if command -v git prompt > /dev/null; then
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

# Neovim Manager (bob)
if [ -d ~/.local/share/bob/nvim-bin/ ]; then
  export PATH="$PATH:$HOME/.local/share/bob/nvim-bin/"
  if ! command -v nvim > /dev/null; then
    bob use stable
  fi
fi

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
elif command -v vim > /dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
fi

# Private Configuration (Not source controlled)
if [ -f ~/.bashrc_private ]; then
    source ~/.bashrc_private
fi

# SSH
if [ -d ~/.ssh ]; then
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/id_rsa 2> /dev/null
fi

# Nix Home Manager
if [ -f ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  source ~/.nix-profile/etc/profile.d/hm-session-vars.sh
fi

# Pip && Python Dependency Manager (pdm)
if [ -d ~/.local/bin ]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

# Sdkman
if [ -d ~/.sdkman ]; then
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Rust
if [ -d ~/.cargo ]; then
  if [ -f ~/.cargo/env ]; then
    source ~/.cargo/env
  else
    export PATH="$PATH:$HOME/.cargo/bin"
  fi
fi

# Go
if [ -d /usr/local/go/bin ]; then
    export PATH="$PATH:/usr/local/go/bin"
fi
if [ -d ~/go/bin ]; then
    export PATH="$PATH:~/go/bin"
fi

# Fuzzy Find (fzf)
if command -v fzf > /dev/null; then
  if [[ ! "$PATH" == */.fzf/bin* ]]; then
    PATH="$PATH:$HOME/.fzf/bin"
  fi
  eval "$(fzf --bash)"

  # Use fd (rust find)
  if command -v fd > /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# Fast Node Manager (fnm)
if command -v fnm > /dev/null; then
  export DEFAULT_NODE="18"
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  if ! fnm use $DEFAULT_NODE > /dev/null 2> /dev/null; then
    fnm install $DEFAULT_NODE > /dev/null
    fnm use $DEFAULT_NODE > /dev/null
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

# Haskell
if command -v cabal > /dev/null; then
  export PATH="$HOME/.cabal/bin:$PATH"
fi

# Remove Windows npm <https://github.com/microsoft/WSL/issues/3882#issuecomment-543833151>
if is wsl ; then
  export PATH="$(echo "$PATH" | sed 's#:/mnt/c/Program Files/nodejs/##g')"
fi

# Dotnet
if [ -d "$HOME/.dotnet" ]; then
  export PATH="$HOME/.dotnet:$PATH"
  export PATH="$HOME/.dotnet/tools:$PATH"
fi

# Aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi

# GritQL
if [ -f "$HOME/.grit/bin/env" ]; then
  source "$HOME/.grit/bin/env"
fi
