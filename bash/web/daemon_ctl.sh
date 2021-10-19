#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	pushd $HERMES_HOME	
	supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf
	popd
}

# Invoke entry point.
main