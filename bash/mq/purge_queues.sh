# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Purge debug queues.
source $PRODIGUER_HOME/bash/mq/purge_queues_debug.sh $1

# Purge live queues.
source $PRODIGUER_HOME/bash/mq/purge_queues_live.sh $1
