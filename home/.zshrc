#------------------------------------------------------------------------
# brew
#------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# Add brew auto-completions to zsh lookup path
pathadd fpath "${HOMEBREW_PREFIX}/share/zsh/site-functions"
autoload -Uz compinit && compinit

#------------------------------------------------------------------------
# spack
#------------------------------------------------------------------------
export SPACK_SKIP_MODULES=1
source_if_exists $HOME/src/spack/spack/share/spack/setup-env.sh

default_env=$HOME/.spack/environments/default/.spack-env/view
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
    eval "$(direnv hook zsh)"
fi

#------------------------------------------------------------------------
# fzf
#------------------------------------------------------------------------
if type fzf &>/dev/null; then
    source "${default_env}/share/fzf/shell/key-bindings.zsh"
    source "${default_env}/share/fzf/shell/completion.zsh"
fi

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git'
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
alias estop="emacsclient -e '(kill-emacs)'"
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
if \ls --color -d . >/dev/null 2>&1; then
    export LS_OPTIONS="--color=auto -F -B"
    export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;\
                      43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
elif \ls -G -d . >/dev/null 2>&1; then
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

# Use the system's max stack size: prevents crashes on cluster apps.
ulimit -s $(ulimit -Hs)

# enable/disable core dumps
# ulimit -c $(ulimit -Hc)
ulimit -c 0

#------------------------------------------------------------------------
# make key bindings for M-[fb], M-delete, etc. work
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
# history
#------------------------------------------------------------------------
export HISTSIZE=10000      # set history size
export SAVEHIST=10000      # save history after logout
setopt INC_APPEND_HISTORY  # append into history file
setopt HIST_IGNORE_DUPS    # save only one command if 2 are same
setopt EXTENDED_HISTORY    # add timestamp for each entry

#------------------------------------------------------------------------
# other settings
#------------------------------------------------------------------------
# alias ssh to custom configuration file to prevent override
if [ -f $HOME/.ssh/default ]; then
    alias ssh="ssh -F $HOME/.ssh/default"
    export GIT_SSH_COMMAND="ssh -F $HOME/.ssh/default"
fi

# manually forward agent when required and ignore existing connections
alias ssha='ssh -A -S none'

# make grep highlight search string in red
alias grep='grep --color=auto'

# make which behave like it does elsewhere
alias which='whence -p'

# make an alias for getting to the dotfiles git repo
alias cddot='cd ${HOME}/src/${USER}/dotfiles/'
