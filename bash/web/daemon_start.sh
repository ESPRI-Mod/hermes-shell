#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	# Reset supervisord log.
	rm $HERMES_DIR_DAEMONS/web/supervisor.log

	# Launch daemon.
	pushd $HERMES_HOME
	supervisord -c $HERMES_DIR_DAEMONS/web/supervisord.conf
	popd

	# Display status.
	sleep 2.0
	source $HERMES_HOME/bash/web/daemon_status.sh

	log "WEB : initialized daemon"
}

# Invoke entry point.
main