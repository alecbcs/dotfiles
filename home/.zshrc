#------------------------------------------------------------------------
# Brew
#------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add brew auto-completions to zsh lookup path
pathadd fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions"
autoload -Uz compinit && compinit

#------------------------------------------------------------------------
# Spack
#------------------------------------------------------------------------
export SPACK_SKIP_MODULES=1
source_if_exists $HOME/src/spack/spack/share/spack/setup-env.sh

default_env=$HOME/.spack/environments/default/.spack-env/view
pathadd $default_env/bin

alias cdsp="cd $SPACK_ROOT"
alias s="spack"

#------------------------------------------------------------------------
# ~/.bin
#------------------------------------------------------------------------
pathadd "{$HOME}/.bin"

#------------------------------------------------------------------------
# Direnv
#------------------------------------------------------------------------
if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi

#------------------------------------------------------------------------
# Go
#------------------------------------------------------------------------
pathadd GOPATH "${HOME}/go"
pathadd "${GOPATH}/bin"

#------------------------------------------------------------------------
# Python
#------------------------------------------------------------------------
pathadd "${HOME}/.local/bin"

#------------------------------------------------------------------------
# Editors
#------------------------------------------------------------------------
# Set system editor.
export EDITOR="emacsclient -nw -a ''"

# Emacs setup
# Various emacs aliases.
alias estop="emacsclient -e '(save-buffers-kill-emacs)'"

alias emacs="$EDITOR"
alias e="$EDITOR"

#------------------------------------------------------------------------
# GPG Settings
#------------------------------------------------------------------------
export GPG_TTY=$(tty)

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
# History
#------------------------------------------------------------------------
export HISTSIZE=10000      # set history size
export SAVEHIST=10000      # save history after logout
setopt INC_APPEND_HISTORY  # append into history file
setopt HIST_IGNORE_DUPS    # save only one command if 2 are same
setopt EXTENDED_HISTORY    # add timestamp for each entry

#------------------------------------------------------------------------
# Other settings
#------------------------------------------------------------------------
# make grep highlight search string in red
alias grep='grep --color=auto'

# make which behave like it does elsewhere
alias which='whence -p'

# make an alias for getting to the dotfiles git repo
alias cddot='cd ${HOME}/src/${USER}/dotfiles/'
