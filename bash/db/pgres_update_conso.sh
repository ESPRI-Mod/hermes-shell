#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	log "initialising conso db tables"

	activate_venv server
	python $PRODIGUER_DIR_JOBS/db/pgres_update_conso.py


	log "initialised conso db tables"
}

# Invoke entry point.
main