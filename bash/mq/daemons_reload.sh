#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	pushd $HERMES_HOME

	source $HERMES_HOME/bash/mq/daemons_stop_phase_1.sh
	sleep 10.0
	source $HERMES_HOME/bash/mq/daemons_stop.sh
	sleep 5.0
	source $HERMES_HOME/bash/mq/daemons_start.sh

	popd
}

# Invoke entry point.
main