#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING STACK"

	source $HERMES_HOME/bash/stack/update_shell.sh
	source $HERMES_HOME/bash/stack/update_config.sh
	source $HERMES_HOME/bash/stack/update_environment_vars.sh
	source $HERMES_HOME/bash/stack/update_repos.sh
	source $HERMES_HOME/bash/stack/update_venv.sh

	log "UPDATED STACK"

	_update_notice
}

# Invoke entry point.
main
