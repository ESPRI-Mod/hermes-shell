#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "UPDATING SHELL"

	set_working_dir
	git pull -q
	remove_files "*.pyc"

	log "UPDATED SHELL"
}

# Invoke entry point.
main
