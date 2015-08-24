# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Set of supported MQ queues.
declare -a QUEUES=(
	'ext-smtp'
	'in-metrics-env'
	'in-metrics-sim'
	'in-monitoring-compute'
	'in-monitoring-post-processing'
	'internal-api'
	'internal-cv'
)

log "MQ : purging live queues ..."

for queue in "${QUEUES[@]}"
do
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-$queue
done

log "MQ : purged live queues"

source $PRODIGUER_HOME/bash/mq/purge_queues_debug.sh
