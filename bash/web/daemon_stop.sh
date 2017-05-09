#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	# Kill daemon.
	activate_venv
	supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf stop all
	supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf shutdown

	log "WEB : killed daemon"
}

# Invoke entry point.
main