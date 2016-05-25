#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "initialising conso db tables"

	activate_venv server
	python $HERMES_DIR_JOBS/db/run_pgres_update_conso.py


	log "initialised conso db tables"
}

# Invoke entry point.
main