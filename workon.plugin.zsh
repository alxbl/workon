#!/bin/env zsh
# Script:      Workon
# Description: A zsh plugin to make working with multiple projects easier.
# Author:      Alexandre "alxbl" Beaulieu <alex@segfault.me>
###

function _get_path_bash {
}

function _get_path_zsh {
}

function _workon_switch_to {
    p=$1 # The project name

    # Context lookup
    for d in ${=WORKSPACES//:/ }; do
        # Highest Priority: tmuxinator project definition overrides all.
        if command -v tmuxinator &>/dev/null ; then
            # Project directory
            if [ -f "$d/$p/.tmuxinator.yml" ]; then
                tmuxinator start -p "$d/$p/.tmuxinator.yml"
                return 0
            fi
            # Workspace
            if [ -f "$d/$p.yml" ]; then
                tmuxinator start -p "$d/$p.yml"
                return 0
            fi
            # Global
            if [ -f "$HOME/.config/tmuxinator/$p.yml" ]; then
                tmuxinator $p
                return 0
            fi
        fi
        # Next: Check for a project directory
        if [ -d "$d/$p" ]; then
            # A pipenv project?
            if [ -f "$d/$p/Pipfile" ]; then
                cd "$d/$p" && pipenv shell
            fi
            # Fallback, just cd there.
            echo "[*] Switching to project: $p"
            cd "$d/$p"
            return 0
        fi
    done
    echo "[!] Project not found :("
    return 127
}

function workon {
    # Load workspaces from environment  if present.
    if [ ! -v WORKSPACES ]; then
        WORKSPACES="$HOME/Work"
    fi

    if [ $# -ne 1 ]; then
        echo "Usage: $0 <project>"
        return 1
    fi
    _workon_switch_to $1
}
# }}}
# vim:syntax=zsh:fdm=marker:

