#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "Updating virtual environment"

	# Set variables.
	declare HERMES_DIR_VENV=$HERMES_HOME/ops/python/venv
	declare HERMES_DIR_PYTHON=$HERMES_HOME/ops/python
	declare HERMES_PYTHON=$HERMES_HOME/ops/python/bin/python
	declare HERMES_REQUIREMENTS=$HERMES_HOME/templates/venv-requirements-server.txt

	# Set paths.
    export PATH=$HERMES_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$HERMES_DIR_PYTHON:$PYTHONPATH

    # Activate venv.
    source $HERMES_DIR_VENV/bin/activate

	# Upgrade pip / virtual env.
	pip install --upgrade pip
	pip install --upgrade virtualenv

    # Upgrade dependencies.
    pip install --allow-all-external --upgrade -r $HERMES_REQUIREMENTS

	# Clean up.
	deactivate
}

# Invoke entry point.
main
