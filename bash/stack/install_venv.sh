#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
    log "Installing virtual environment"

    # Set variables.
    declare HERMES_DIR_VENV=$HERMES_HOME/ops/python/venv
    declare HERMES_DIR_PYTHON=$HERMES_HOME/ops/python
    declare HERMES_REQUIREMENTS=$HERMES_HOME/templates/venv-requirements-server.txt

    # Reset.
    rm -rf $HERMES_DIR_VENV
    mkdir -p $HERMES_DIR_VENV

    # Set paths.
    export PATH=$HERMES_DIR_PYTHON/bin:$PATH
    export PYTHONPATH=$HERMES_DIR_PYTHON:$PYTHONPATH

    # Upgrade pip / virtual env.
    pip install --upgrade pip
    pip install --upgrade virtualenv

    # Initialize venv.
    virtualenv -q $HERMES_DIR_VENV
    source $HERMES_DIR_VENV/bin/activate

    # Install dependencies.
    pip install --allow-all-external -r $HERMES_REQUIREMENTS

    # Clean up.
    deactivate
}

# Invoke entry point.
main
