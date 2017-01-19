#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing repos ..."

    for repo in "${HERMES_REPOS[@]}"
    do
        _install_repo $repo
    done
}

# Installs a git repo.
_install_repo()
{
    log "Installing repo: $1"

    rm -rf $HERMES_DIR_REPOS/$1
    git clone -q $HERMES_GITHUB/$1.git $HERMES_DIR_REPOS/$1
}

# Invoke entry point.
main
