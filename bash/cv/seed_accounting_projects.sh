#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Seeding cv termset: accounting project ..."

	activate_venv
	pushd $HERMES_HOME
	pipenv run python $HERMES_DIR_JOBS/cv/run_seed_accounting_projects.py
	popd
}

# Invoke entry point.
main
