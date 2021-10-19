#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Launching web service API"
	pushd $HERMES_HOME
	activate_venv
	pipenv run python $HERMES_DIR_JOBS/web/run_web_service.py
	popd
}

# Invoke entry point.
main