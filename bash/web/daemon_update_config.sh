#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	cp $HERMES_DIR_TEMPLATES/web-supervisord.conf $HERMES_DIR_DAEMONS/web/supervisord.conf

	log "WEB : updated daemon config"
}

# Invoke entry point.
main