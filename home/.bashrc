#------------------------------------------------------------------------
# Initial definitions
#------------------------------------------------------------------------
# Prepends directories to path, if they exist.
#      pathadd /path/to/dir            # add to PATH
# or   pathadd OTHERPATH /path/to/dir  # add to OTHERPATH
function pathadd {
    # If no variable name is supplied, just append to PATH
    # otherwise append to that variable.
    _pa_varname=PATH
    _pa_new_path="$1"
    if [ -n "$2" ]; then
        _pa_varname="$1"
        _pa_new_path="$2"
    fi

    # Do the actual prepending here.
    eval "_pa_oldvalue=\$${_pa_varname}"

    if [ -d "$_pa_new_path" ] && [[ ":$_pa_oldvalue:" != *":$_pa_new_path:"* ]];
    then
        # Convert path to absolute path if it is not one.
        _pa_new_path=$(cd $_pa_new_path && pwd)

        # Add it to the PATH.
        if [ -n "$_pa_oldvalue" ]; then
            eval "export $_pa_varname=\"$_pa_new_path:$_pa_oldvalue\""
        else
            export $_pa_varname="$_pa_new_path"
        fi
    fi
}

# Remove duplicate entries from PATH.
function clean_path {
    export PATH=$(echo "$PATH" | \
                  awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}')
}

# Source a file if it exists
function source_if_exists {
    if [ -f "$1" ]; then
        . "$1"
    fi
}

# Disable stupid X11 programs that ask for your ssh password.
export SSH_ASKPASS=

source_if_exists /etc/lc.bashrc
source_if_exists /etc/bashrc

#------------------------------------------------------------------------
# EXIT HERE if this is a non-interactive shell
#------------------------------------------------------------------------
# Test whether this is an interactive shell.
case $- in
    *i*) ;;       # interactive
    *) return ;;  # non-interactive
esac

#------------------------------------------------------------------------
# spack
#------------------------------------------------------------------------
export SPACK_SKIP_MODULES=1
source_if_exists $HOME/src/spack/spack/share/spack/setup-env.sh

default_env=${HOME}/.spack/environments/default/.spack-env/view
pathadd $default_env/bin

alias cdsp="cd ${SPACK_ROOT}"
alias s="spack"

#------------------------------------------------------------------------
# ~/.bin
#------------------------------------------------------------------------
pathadd "${HOME}/.bin"

#------------------------------------------------------------------------
# direnv
#------------------------------------------------------------------------
export DIRENV_WARN_TIMEOUT=30s
if type direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

#------------------------------------------------------------------------
# fzf
#------------------------------------------------------------------------
if type fzf &>/dev/null; then
    source "${default_env}/share/fzf/shell/key-bindings.bash"
    source "${default_env}/share/fzf/shell/completion.bash"
fi

export FZF_DEFAULT_COMMAND='bfs . -exclude -name .git 2>/dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

#------------------------------------------------------------------------
# go
#------------------------------------------------------------------------
export GOPATH="${HOME}/go"
pathadd "${GOPATH}/bin"

#------------------------------------------------------------------------
# python
#------------------------------------------------------------------------
pathadd "${HOME}/.local/bin"

#------------------------------------------------------------------------
# editors
#------------------------------------------------------------------------
# Set system editor.
export EDITOR="emacsclient -nw -a ''"

# Emacs setup
# Various emacs aliases.
alias estop="emacsclient -e '(save-buffers-kill-emacs)'"
alias emacs="$EDITOR"
alias e="$EDITOR"

#------------------------------------------------------------------------
# gpg settings
#------------------------------------------------------------------------
export GPG_TTY=$(tty)

#------------------------------------------------------------------------
# ls options
#------------------------------------------------------------------------
# Give ls decent colors and options depending on version.
if ls --color -d . >/dev/null 2>&1; then
    export LS_OPTIONS="--color=auto -F -B"
    export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;\
                      43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
elif ls -G -d . >/dev/null 2>&1; then
    export LS_OPTIONS="-G -F"
    export LSCOLORS="exfxcxdxbxegedabagacad"
fi

alias ls="ls $LS_OPTIONS"
alias ll="ls -lh $LS_OPTIONS"
alias lsla="ls -la $LS_OPTIONS"

#------------------------------------------------------------------------
# limits and shell settings
#------------------------------------------------------------------------
stty erase '^?'

# use the system's max stack size: prevents crashes on cluster apps.
ulimit -s $(ulimit -Hs)

# enable/disable core dumps
# ulimit -c $(ulimit -Hc)
ulimit -c 0

# Make bash set LINES and COLUMNS after each command.
shopt -s checkwinsize

# Shorten and customize terminal bash prompt.
export PS1="\u@\h:\W\$ "

#------------------------------------------------------------------------
# history
#------------------------------------------------------------------------
# append instead of overwrite (good for multiple sessions)
shopt -s histappend

# don't save duplicate entries
export HISTCONTROL=ignoreboth
export HISTSIZE=10000

#------------------------------------------------------------------------
# other settings
#------------------------------------------------------------------------
# alias ssh to custom configuration file to prevent override
alias ssh="ssh -F $HOME/.ssh/default"

# make grep highlight search string in red.
alias grep='grep --color=auto'

# make an alias for getting to the dotfiles git repo
alias cddot="cd ${HOME}/src/${USER}/dotfiles/"
