#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/web/daemons_kill.sh
	source $HERMES_HOME/bash/web/daemons_init.sh
	sleep 3.0
	source $HERMES_HOME/bash/web/daemons_status.sh
}

# Invoke entry point.
main