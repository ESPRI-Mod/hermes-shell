#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING STACK"

	source $PRODIGUER_HOME/bash/stack/update_shell.sh
	source $PRODIGUER_HOME/bash/stack/update_config.sh
	source $PRODIGUER_HOME/bash/stack/update_repos.sh
	source $PRODIGUER_HOME/bash/stack/update_venvs.sh

	log "UPDATED STACK"

	_update_notice
}

# Invoke entry point.
main
