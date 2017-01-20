#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing repos ..."

    for repo in "${HERMES_REPOS[@]}"
    do
	    rm -rf $HERMES_DIR_REPOS/$repo
	    git clone -q $HERMES_GITHUB/$repo.git $HERMES_DIR_REPOS/$repo
    done
}

# Invoke entry point.
main
