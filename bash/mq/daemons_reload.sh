#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/mq/daemons_kill_phase_1.sh
	sleep 10.0
	source $HERMES_HOME/bash/mq/daemons_kill_phase_2.sh
	source $HERMES_HOME/bash/mq/daemons_init.sh
	sleep 5.0
	source $HERMES_HOME/bash/mq/daemons_status.sh
}

# Invoke entry point.
main