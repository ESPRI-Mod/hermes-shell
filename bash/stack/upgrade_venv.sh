#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Main entry point.
main()
{
	log "UPGRADING VIRTUAL ENVIRONMENT"

	export PATH=$PRODIGUER_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_PYTHON
	declare TARGET_VENV=$PRODIGUER_DIR_VENV/$1
	declare TARGET_VENV_REQUIREMENTS=$PRODIGUER_DIR_TEMPLATES/venv-requirements-$1.txt
    source $TARGET_VENV/bin/activate
    pip install -q --allow-all-external --upgrade -r $TARGET_VENV_REQUIREMENTS

	log "UPGRADED VIRTUAL ENVIRONMENT"
}

# Invoke entry point.
main $1