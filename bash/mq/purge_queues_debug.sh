# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Set of supported debug MQ queues.
declare -a QUEUES=(
	'debug-ext-smtp'
	'debug-internal-api'
	'debug-internal-cv'
	'in-monitoring-0000'
	'in-monitoring-0100'
	'in-monitoring-1000'
	'in-monitoring-1100'
	'in-monitoring-2000'
	'in-monitoring-2100'
	'in-monitoring-2900'
	'in-monitoring-3000'
	'in-monitoring-3100'
	'in-monitoring-3900'
	'in-monitoring-4000'
	'in-monitoring-4100'
	'in-monitoring-4900'
	'in-monitoring-7000'
	'in-monitoring-7100'
	'in-monitoring-8888'
	'in-monitoring-9000'
	'in-monitoring-9999'
)

log "MQ : purging debug queues ..."

for queue in "${QUEUES[@]}"
do
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-$queue
done

log "MQ : purged debug queues ..."
