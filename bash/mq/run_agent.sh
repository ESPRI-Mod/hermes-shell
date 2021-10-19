#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	activate_venv
	pushd $HERMES_HOME
	pipenv run python $HERMES_DIR_JOBS"/mq" --agent-type=$1 --agent-limit=$2 --agent-parameter=$3
	popd
}

# Invoke entry point.
main $1 $2 $3