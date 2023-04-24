#!/bin/bash
# Executed by bash(1) for non-login shells.

# Exit if this shell should not be interative
case $- in
    *i*) ;;
      *) return;;
esac

function is_termux()
{
  command -v termux-setup-storage > /dev/null
}

function is_wsl()
{
  command -v wslpath > /dev/null
}

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

# Prompt (https://unix.stackexchange.com/a/124409/194972)
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
prompt=" \$ "
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
fi

# Editor
if command -v nvim > /dev/null; then
  export EDITOR=nvim
elif command -v vim > /dev/null; then
  export EDITOR=vim
else
  export EDITOR=vi
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

# Zoxide
if command -v zoxide > /dev/null; then
  eval "$(zoxide init bash)"
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
    export SDKMAN_DIR="$HOME/.sdkman"
    [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Rust
if [ -d ~/.cargo ]; then
    source ~/.cargo/env
fi

# Go
if [ -d /usr/local/go/bin ]; then
    export PATH="$PATH:/usr/local/go/bin"
fi

# Fuzzy Find (fzf)
if [ -d "$HOME/.fzf/bin" ]; then
  # Setup fzf
  # ---------
  if [[ ! "$PATH" == */.fzf/bin* ]]; then
    PATH="$PATH:$HOME/.fzf/bin"
  fi

  # Auto-completion
  # ---------------
  [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

  # Key bindings
  # ------------
  source "$HOME/.fzf/shell/key-bindings.bash"

  # Use fd (rust find)
  if command -v fd > /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# Fast Node Manager (fnm)
if [ -d ~/.local/share/fnm ]; then
  DEFAULT_NODE="18"
  export PATH="$HOME/.local/share/fnm:$PATH"
  eval "$(fnm env)"
  fnm use $DEFAULT_NODE > /dev/null
fi

# Remove Windows npm (https://github.com/microsoft/WSL/issues/3882#issuecomment-543833151)
if is_wsl ; then
  export PATH="$(echo "$PATH" | sed 's#:/mnt/c/Program Files/nodejs/##g')"
fi
