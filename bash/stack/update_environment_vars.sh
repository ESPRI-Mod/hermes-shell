#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	declare backup=$HOME/.prodiguer-"`date +%Y-%m-%d`"
	cp $HOME/.prodiguer $backup
	cp $PRODIGUER_DIR_TEMPLATES/prodiguer_env.sh $HOME/.prodiguer

	log "UPDATED ENVIRONMENT VARS"
	log "previous configuration file backup @ "$backup
}

# Invoke entry point.
main
