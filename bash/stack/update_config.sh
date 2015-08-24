#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING CONFIG"

	cp $PRODIGUER_DIR_TEMPLATES/prodiguer.json $PRODIGUER_DIR_CONFIG/prodiguer.json
	cp $PRODIGUER_DIR_TEMPLATES/mq-supervisord.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
	cp $PRODIGUER_DIR_TEMPLATES/web-supervisord.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

	log "UPDATED CONFIG"
}

# Invoke entry point.
main