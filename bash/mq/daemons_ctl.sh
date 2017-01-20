#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	activate_venv
	supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf
}

# Invoke entry point.
main