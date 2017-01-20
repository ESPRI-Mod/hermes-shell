#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	cp $HERMES_DIR_TEMPLATES/mq-supervisord-$HERMES_DEPLOYMENT_MODE.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf
	log "MQ : updated daemons config"
}

# Invoke entry point.
main