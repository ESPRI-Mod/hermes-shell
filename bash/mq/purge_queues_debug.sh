# Import utils.
source $HERMES_HOME/bash/init.sh

# Set of supported debug MQ queues.
declare -a QUEUES=(
	'debug-0000'
	'debug-0100'
	'debug-1000'
	'debug-1001'
	'debug-1100'
	'debug-1900'
	'debug-1999'
	'debug-2000'
	'debug-2100'
	'debug-2900'
	'debug-2999'
	'debug-3000'
	'debug-3100'
	'debug-3900'
	'debug-3999'
	'debug-7000'
	'debug-7010'
	'debug-7011'
	'debug-7100'
	'debug-8000'
	'debug-8100'
	'debug-8200'
	'debug-alert'
	'debug-cv'
	'debug-fe'
	'debug-smtp'
)

for queue in "${QUEUES[@]}"
do
	log "MQ : purging debug queue :: "$queue
	rabbitmqadmin -q -u hermes-mq-admin -p $1 -V hermes purge queue name=$queue
done

log "MQ : purged debug queues"
