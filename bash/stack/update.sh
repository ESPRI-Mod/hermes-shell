#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING STACK"

	prodiguer-stack-update-shell
	prodiguer-stack-update-config
	prodiguer-stack-update-repos
	prodiguer-stack-upgrade-venvs

	log "UPDATED STACK"

	_update_notice
}

# Invoke entry point.
main
