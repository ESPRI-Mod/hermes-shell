#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/mq/purge_queues_debug.sh
	source $HERMES_HOME/bash/mq/purge_queues_live.sh
}

# Invoke entry point.
main