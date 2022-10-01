#------------------------------------------------------------------------
# Brew environment and paths
#------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

#------------------------------------------------------------------------
# Go
#------------------------------------------------------------------------
export GOPATH="${HOME}/src/go"
pathadd "${GOPATH}/bin"

#------------------------------------------------------------------------
# Editors
#------------------------------------------------------------------------
# Set system editor.
export EDITOR="emacsclient -nw -a ''"

# Emacs setup
# Various emacs aliases.
alias emacs="$EDITOR"
alias e="$EDITOR"

#------------------------------------------------------------------------
# Diceware
#------------------------------------------------------------------------
# Display diceware words from list based on id.
function diceware {
    echo $(cat $HOME/.diceware-wordlist.txt | grep $@)
}

#------------------------------------------------------------------------
# ls options
#------------------------------------------------------------------------
# Give ls decent colors and options depending on version.
if \ls --color -d . >/dev/null 2>&1; then
    export LS_OPTIONS="--color=auto -F -B"
elif \ls -G -d . >/dev/null 2>&1; then
    export LS_OPTIONS="-G -F"
fi

alias ls="ls $LS_OPTIONS"
alias ll="ls -lh $LS_OPTIONS"
alias lsla="ls -la $LS_OPTIONS"

#------------------------------------------------------------------------
# Limits and shell settings
#------------------------------------------------------------------------
stty erase '^?'

# Use the system's max stack size: prevents crashes on cluster apps.
ulimit -s $(ulimit -Hs)

# enable/disable core dumps
# ulimit -c $(ulimit -Hc)
ulimit -c 0

#------------------------------------------------------------------------
# Make key bindings for M-[fb], M-delete, etc. work
#------------------------------------------------------------------------
bindkey -me >& /dev/null
bindkey '[3~' delete-char
bindkey '[4~' end-of-line
bindkey '[1~' beginning-of-line
bindkey 'OH' beginning-of-line
bindkey 'OF' end-of-line
bindkey '[H' beginning-of-line
bindkey '[F' end-of-line
bindkey '[1;3D' beginning-of-line
bindkey '[1;3C' end-of-line
bindkey '[1;9C' forward-word
bindkey '[1;9D' backward-word

#------------------------------------------------------------------------
# Other settings
#------------------------------------------------------------------------

# Make grep highlight search string in red
export GREP_OPTIONS='--color=auto'

# make which behave like it does elsewhere
alias which='whence -p'

#------------------------------------------------------------------------
# History
#------------------------------------------------------------------------

export HISTSIZE=10000      # set history size
export SAVEHIST=10000      # save history after logout
setopt INC_APPEND_HISTORY  # append into history file
setopt HIST_IGNORE_DUPS    # save only one command if 2 are same
setopt EXTENDED_HISTORY    # add timestamp for each entry

# Setup GPG
export GPG_TTY=$(tty)
