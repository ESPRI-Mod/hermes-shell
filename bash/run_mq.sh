#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Set of supported MQ queues.
declare -a MQ_QUEUES=(
	'ext-log'
	'ext-smtp'
	'in-log'
	'in-monitoring-0000'
	'in-monitoring-0100'
	'in-monitoring-1000'
	'in-monitoring-1100'
	'in-monitoring-2000'
	'in-monitoring-3000'
	'in-monitoring-7000'
	'in-monitoring-8888'
	'in-monitoring-9000'
	'in-monitoring-9999'
	'internal-api'
	'internal-smtp'
)

# Launch server.
run_mq_server()
{
	rabbitmq-server
}

run_mq_purge_queues()
{
	log "MQ : purging queues ..."

	for queue in "${MQ_QUEUES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-$queue
	done

	log "MQ : purged queues ..."
}

_run_mq_agent()
{
	declare agent=$1
	declare typeof=`echo $2 | tr '-' '_'`
	declare limit=$3

	log "MQ : launching "$typeof" MQ "$agent" ..."

    activate_venv server
	python $DIR_SCRIPTS"/jobs/mq/"$agent"s/"$typeof".py" $limit

	log "MQ : launched "$typeof" MQ "$agent" ..."
}

run_mq_producer()
{
	declare typeof=$1
	declare limit=$2

	_run_mq_agent "producer" $typeof $limit
}

run_mq_consumer()
{
	declare typeof=$1
	declare limit=$2

	log "MQ : launching consumer: "$typeof

    activate_venv server
	python $DIR_SCRIPTS"/jobs/mq/consumer" $typeof $limit
}

run_mq_consumers()
{
	log "MQ : launching consumers ..."

	for queue in "${MQ_QUEUES[@]}"
	do
		run_mq_consumer $queue &
	done
}

run_mq_to_api()
{
	log "TODO"
}
