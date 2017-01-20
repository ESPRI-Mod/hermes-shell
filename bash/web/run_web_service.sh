#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Launching web service API"
	activate_venv
	python $HERMES_DIR_JOBS/web/run_web_service.py
}

# Invoke entry point.
main