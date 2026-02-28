typeset -U path
skip_global_compinit=1

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
        # Use :A modifier for absolute path - much faster than cd in subshell
        _pa_new_path="${_pa_new_path:A}"

        # Add it to the PATH.
        if [ -n "$_pa_oldvalue" ]; then
            eval "export $_pa_varname=\"$_pa_new_path:$_pa_oldvalue\""
        else
            export $_pa_varname="$_pa_new_path"
        fi
    fi
}

# Source a file if it exists
function source_if_exists {
    if [ -f "$1" ]; then
        . "$1"
    fi
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

# Automatically apply --signoff to the relevant commands
function git {
    case $1 in
        commit|revert)
            local cmd=$1
            shift
            command git $cmd --signoff "$@"
            ;;
        rebase)
            shift
            # Don't add --signoff for continue/skip/abort
            if [[ $1 == (--continue|--skip|--abort) ]]; then
                command git rebase "$@"
            else
                command git rebase --signoff "$@"
            fi
            ;;
        *)
            command git "$@"
            ;;
    esac
}

# Function to get deterministic color based on hostname (using 256 colors)
function get_host_color {
    local hostname=$(hostname)
    # Remove trailing numbers from hostname
    local base_hostname=${hostname%%[0-9]*}

    # Curated palette of pleasant colors (256-color codes)
    local colors=(
        # Blues
        33 39 45 51 blue 81 87 117 123 159 165 171
        # Greens
        28 34 70 76 112 148 154
        # Purples/Magentas
        55 61 91 97 127 133 163 169 199 205
        # Oranges/Reds
        130 136 166 172 202 208 214 220
        # Yellows/Golds
        142 178 180
        # Cyans/Teals
        30 36 42 72 78 108 114 150 156 186 192
        # Warm Grays
        102 138 144 173 179
        # Soft Browns/Tans
        94 95 101 137 143 179
    )

    # Create a simple hash of the base hostname
    local hash=0
    for (( i=1; i<=${#base_hostname}; i++ )); do
        local char_code=$(printf "%d" "'${base_hostname[i]}")
        hash=$((hash + char_code))
    done

    # Use modulo to pick a color index
    local color_index=$(((hash % ${#colors[@]}) + 1))
    echo ${colors[color_index]}
}

# Cache homebrew prefix for performance (used in .zshrc)
if type brew &>/dev/null; then
    export HOMEBREW_PREFIX=$(brew --prefix)
fi

# disable stupid X11 programs that ask for your ssh password
export SSH_ASKPASS=
