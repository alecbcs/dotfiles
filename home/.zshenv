typeset -U path

# Prepends directories to path, if they exist.
#      pathadd /path/to/dir            # add to PATH
# or   pathadd OTHERPATH /path/to/dir  # add to OTHERPATH
function pathadd {
    if [ -d "$1" ]; then
        path=($1 "$path[@]")
    elif [ -d "$2" ]; then
        eval "$1=($2 \$$1[@])"
    fi
}

# Source a file if it exists
function source_if_exists {
    if [ -f "$1" ]; then
        . "$1"
    fi
}

function git_branch {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

function prompt_pwd {
    local i pwd
    pwd=("${(s:/:)PWD/#$HOME/~}")
    if (( $#pwd > 1 )); then
        for i in {1..$(($#pwd-1))}; do
            if [[ "$pwd[$i]" = .* ]]; then
                pwd[$i]="${${pwd[$i]}[1,2]}"
            else
                pwd[$i]="${${pwd[$i]}[1]}"
            fi
        done
    fi
    echo "${(j:/:)pwd}"
}

# disable stupid X11 programs that ask for your ssh password
export SSH_ASKPASS=
