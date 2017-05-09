#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/mq/daemons_stop_phase_1.sh
	sleep 10.0
	source $HERMES_HOME/bash/mq/daemons_stop_phase_2.sh
	sleep 5.0
	source $HERMES_HOME/bash/mq/daemons_start.sh
}

# Invoke entry point.
main