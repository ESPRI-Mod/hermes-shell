#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Sending a test monitoring event"
	activate_venv
	python $HERMES_DIR_JOBS/web/test_monitoring_event.py -mt=$1 -sim=$2 -job=$3
}

# Invoke entry point.
main $1 $2 $3

