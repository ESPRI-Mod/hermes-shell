#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	# Reset supervisord log.
	rm $HERMES_DIR_DAEMONS/web/supervisor.log

	# Launch daemon.
	activate_venv
	supervisord -c $HERMES_DIR_DAEMONS/web/supervisord.conf

	log "WEB : initialized daemons"
}

# Invoke entry point.
main