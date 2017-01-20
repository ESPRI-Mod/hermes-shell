#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	source $HERMES_HOME/bash/mq/purge_queues_debug.sh $1
	source $HERMES_HOME/bash/mq/purge_queues_live.sh $1
}

# Invoke entry point.
main $1