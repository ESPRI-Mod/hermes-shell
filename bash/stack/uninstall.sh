#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "UNINSTALLING STACK"

	rm -rf $HERMES_HOME

	log "UNINSTALLED STACK"
}

# Invoke entry point.
main
