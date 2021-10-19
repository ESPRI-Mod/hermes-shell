#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "MQ : stopping live-smtp-realtime email listener ..."

	pushd $HERMES_HOME
	supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf stop live-smtp-realtime:01
	popd

	log "MQ : stopped live-smtp-realtime email listener ..."
}

# Invoke entry point.
main