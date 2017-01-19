#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "UPDATING ENVIRONMENT VARS ..."

	if [ -f $HOME/.hermes ]; then
		declare backup=$HOME/.hermes-"`date +%Y-%m-%d`"
		cp $HOME/.hermes $backup
		log "previous environment variable configuration file backup @ "$backup
	fi
	cp $HERMES_DIR_TEMPLATES/hermes_env.sh $HOME/.hermes

	log "UPDATED ENVIRONMENT VARS"
}

# Invoke entry point.
main
