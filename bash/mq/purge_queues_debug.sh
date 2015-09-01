# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Set of supported debug MQ queues.
declare -a QUEUES=(
	'debug-ext-smtp'
	'debug-in-metrics-env'
	'debug-in-metrics-sim'
	'debug-in-monitoring-0000'
	'debug-in-monitoring-0100'
	'debug-in-monitoring-1000'
	'debug-in-monitoring-1100'
	'debug-in-monitoring-2000'
	'debug-in-monitoring-2100'
	'debug-in-monitoring-2900'
	'debug-in-monitoring-3000'
	'debug-in-monitoring-3100'
	'debug-in-monitoring-3900'
	'debug-in-monitoring-4000'
	'debug-in-monitoring-4100'
	'debug-in-monitoring-4900'
	'debug-in-monitoring-8888'
	'debug-in-monitoring-9000'
	'debug-in-monitoring-9999'
	'debug-internal-api'
	'debug-internal-cv'
)

log "MQ : purging debug queues ..."

for queue in "${QUEUES[@]}"
do
	rabbitmqadmin -q -u prodiguer-mq-admin -p $1 -V prodiguer purge queue name=q-$queue
done

log "MQ : purged debug queues"
