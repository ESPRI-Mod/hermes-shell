#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Seeding pyessv ..."

	activate_venv
	pushd $HERMES_HOME
	pipenv run python $HERMES_DIR_JOBS/cv/run_seed_pyessv.py
	popd
}

# Invoke entry point.
main
