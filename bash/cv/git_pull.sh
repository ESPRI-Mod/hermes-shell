#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Seeding pyessv ..."

	set_working_dir $HERMES_DIR_REPOS/hermes-cv
	git pull
	set_working_dir
}

# Invoke entry point.
main
