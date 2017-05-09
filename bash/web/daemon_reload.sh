#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/web/daemon_stop.sh
	sleep 3.0
	source $HERMES_HOME/bash/web/daemon_start.sh
}

# Invoke entry point.
main