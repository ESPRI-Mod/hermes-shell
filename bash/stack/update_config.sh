#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING CONFIG"

	cp $HERMES_DIR_TEMPLATES/hermes.json $HERMES_DIR_CONFIG/hermes.json

	if [ $HERMES_MACHINE_TYPE = "dev" ]; then
		cp $HERMES_DIR_TEMPLATES/mq-supervisord.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf
		cp $HERMES_DIR_TEMPLATES/web-supervisord.conf $HERMES_DIR_DAEMONS/web/supervisord.conf
	elif [ $HERMES_MACHINE_TYPE = "mq" ]; then
		cp $HERMES_DIR_TEMPLATES/mq-supervisord.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf
	elif [ $HERMES_MACHINE_TYPE = "web" ]; then
		cp $HERMES_DIR_TEMPLATES/web-supervisord.conf $HERMES_DIR_DAEMONS/web/supervisord.conf
	fi

	log "UPDATED CONFIG"
}

# Invoke entry point.
main