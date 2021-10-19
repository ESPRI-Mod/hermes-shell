#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "Sending a test monitoring event"

	pushd $HERMES_HOME
	activate_venv
	pipenv run python $HERMES_DIR_JOBS/web/test_monitoring_event.py -mt=$1 -sim=$2 -job=$3
	popd
}

# Invoke entry point.
main $1 $2 $3

