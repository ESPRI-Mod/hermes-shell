#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "INSTALLING ENVIRONMENT VARS ..."

	cp $HERMES_DIR_TEMPLATES/hermes_env.sh $HOME/.hermes

	log "INSTALLED ENVIRONMENT VARS"
}

# Invoke entry point.
main
