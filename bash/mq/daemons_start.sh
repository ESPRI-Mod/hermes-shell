#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	# Reset supervisord log.
	rm $HERMES_DIR_DAEMONS/mq/supervisor.log

	# Launch daemons.
	activate_venv
	supervisord -c $HERMES_DIR_DAEMONS/mq/supervisord.conf

	# Display status.
	sleep 3.0
	source $HERMES_HOME/bash/mq/daemons_status.sh

	log "MQ : initialized daemons"
}

# Invoke entry point.
main