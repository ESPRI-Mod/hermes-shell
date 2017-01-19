#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing virtual environment"

    # Reset.
    rm -rf $HERMES_DIR_VENV
    mkdir -p $HERMES_DIR_VENV

    # Upgrade pip / virtual env.
    $HERMES_DIR_PYTHON/bin/pip install --upgrade pip
    $HERMES_DIR_PYTHON/bin/pip install --upgrade virtualenv

    # Initialize venv.
    $HERMES_DIR_PYTHON/bin/virtualenv -q $HERMES_DIR_VENV

    # Activate venv.
    source $HERMES_DIR_VENV/bin/activate

    # Install dependencies.
    pip install -r $HERMES_VENV_REQUIREMENTS

    # Clean up.
    deactivate
}

# Invoke entry point.
main
