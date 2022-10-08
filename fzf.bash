# Setup fzf
# ---------
if [[ ! "$PATH" == */home/bbolen/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bbolen/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/bbolen/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/bbolen/.fzf/shell/key-bindings.bash"
