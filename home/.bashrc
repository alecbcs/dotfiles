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
        # convert path to absolute path if it is not one
        _pa_new_path=$(cd $_pa_new_path && pwd)

        # Add it to the PATH
        if [ -n "$_pa_oldvalue" ]; then
            eval "export $_pa_varname=\"$_pa_new_path:$_pa_oldvalue\""
        else
            export $_pa_varname="$_pa_new_path"
        fi
    fi
}

# Remove duplicate entries from PATH
function clean_path {
    export PATH=$(echo "$PATH" | awk -F: '{for (i=1;i<=NF;i++) { if ( !x[$i]++ ) printf("%s:",$i); }}')
}

# Source a file if it exists
function source_if_exists {
    if [ -f "$1" ]; then
        . "$1"
    fi
}

# disable stupid X11 programs that ask for your ssh password
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
# Go
#------------------------------------------------------------------------
export GOPATH="${HOME}/src/go"
pathadd "${GOPATH}/bin"

#------------------------------------------------------------------------
# Editors
#------------------------------------------------------------------------
# Set system editor.
export EDITOR="emacs -nw"

# Emacs setup
# Various emacs aliases.
alias emacs="$EDITOR"
alias e="$EDITOR"

#------------------------------------------------------------------------
# ls options
#------------------------------------------------------------------------
# Give ls decent colors and options depending on version
if ls --color -d . >/dev/null 2>&1; then
    export LS_OPTIONS="--color=auto -F -B"
elif ls -G -d . >/dev/null 2>&1; then
    export LS_OPTIONS="-G -F"
fi

alias ls="ls $LS_OPTIONS"
alias ll="ls -lh $LS_OPTIONS"
alias lsla="ls -la $LS_OPTIONS"

# load appropriate dir colors for terminal
if [ -e "$(which dircolors)" ]; then
    if [ "$TERM" = "xterm-256color" -a -e ~/.dir_colors.256 ]; then
        eval $(dircolors ~/.dir_colors.256)
    else
        eval $(dircolors ~/.dir_colors)
    fi
fi

#------------------------------------------------------------------------
# Limits and shell settings
#------------------------------------------------------------------------
stty erase '^?'

# use the system's max stack size: prevents crashes on cluster apps
ulimit -s $(ulimit -Hs)

# enable/disable core dumps
# ulimit -c $(ulimit -Hc)
ulimit -c 0

# Make bash set LINES and COLUMNS after each command.
shopt -s checkwinsize

# bash history options
shopt -s histappend              # append instead of overwrite (good for multiple sessions)
export HISTCONTROL=ignoreboth    # don't save duplicate entries
export HISTSIZE=10000

#------------------------------------------------------------------------
# Other settings
#------------------------------------------------------------------------
# Make grep highlight search string in red
export GREP_OPTIONS='--color=auto'

# Setup GPG
export GPG_TTY=$(tty)
