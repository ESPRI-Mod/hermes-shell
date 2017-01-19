# Import utils.
source $HERMES_HOME/bash/utils.sh

# Purge debug queues.
source $HERMES_HOME/bash/mq/purge_queues_debug.sh $1

# Purge live queues.
source $HERMES_HOME/bash/mq/purge_queues_live.sh $1
