#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "INSTALLING STACK"

	source $HERMES_HOME/bash/stack/install_config.sh
	source $HERMES_HOME/bash/stack/install_repos.sh
	source $HERMES_HOME/bash/stack/install_python.sh
	source $HERMES_HOME/bash/stack/install_venv.sh

	log "INSTALLED STACK"
}

# Invoke entry point.
main
