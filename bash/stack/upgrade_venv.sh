#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPGRADING VIRTUAL ENVIRONMENT"

	export PATH=$HERMES_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_PYTHON
	declare TARGET_VENV=$HERMES_DIR_VENV/$1
	declare TARGET_VENV_REQUIREMENTS=$HERMES_DIR_TEMPLATES/venv-requirements-$1.txt
    source $TARGET_VENV/bin/activate
    pip install -q --allow-all-external --upgrade -r $TARGET_VENV_REQUIREMENTS

	log "UPGRADED VIRTUAL ENVIRONMENT"
}

# Invoke entry point.
main $1