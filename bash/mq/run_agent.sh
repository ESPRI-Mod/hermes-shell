#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	activate_venv
	python $HERMES_DIR_JOBS"/mq" --agent-type=$1 --agent-limit=$2
}

# Invoke entry point.
main $1 $2