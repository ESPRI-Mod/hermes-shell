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

for queue in "${QUEUES[@]}"
do
	log "MQ : purging live queue :: "$queue
	rabbitmqadmin -q -u prodiguer-mq-admin -p $1 -V prodiguer purge queue name=q-$queue
done

log "MQ : purged live queues"
