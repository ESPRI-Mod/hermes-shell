#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPDATING ENVIRONMENT VARS ..."

	if [ -f $HOME/.prodiguer ]; then
		declare backup=$HOME/.prodiguer-"`date +%Y-%m-%d`"
		cp $HOME/.prodiguer $backup
		log "previous environment variable configuration file backup @ "$backup
	fi
	cp $PRODIGUER_DIR_TEMPLATES/hermes_env.sh $HOME/.prodiguer

	log "UPDATED ENVIRONMENT VARS"
}

# Invoke entry point.
main
