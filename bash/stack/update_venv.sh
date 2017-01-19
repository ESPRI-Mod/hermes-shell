#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Updating virtual environment"

    source $HERMES_DIR_VENV/bin/activate
    pip install --upgrade pip
    pip install --upgrade virtualenv
    pip install --upgrade -r $HERMES_VENV_REQUIREMENTS
    deactivate
}

# Invoke entry point.
main
