#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Set of supported MQ exchanges.
declare -a MQ_VHOSTS=(
	'prodiguer'
)

# Set of supported MQ exchanges.
declare -a MQ_EXCHANGES=(
	'ext'
	'in'
	'internal'
	'out'
)

# Set of supported MQ users.
declare -a MQ_USERS=(
	'libigcm-mq-user'
	'prodiguer-mq-user'
)

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
	# 'internal-sms'
	# 'internal-smtp'
)

_run_mq_agent()
{
	declare agent=$1
	declare typeof=$2
	declare throttle=$3
	declare misc=$4

	log "MQ : launching "$typeof" MQ "$agent" ..."

    activate_venv server
	python $DIR_JOBS"/mq/"$agent $typeof $throttle $misc

	log "MQ : launched "$typeof" MQ "$agent" ..."
}

run_mq_configure()
{
	log "MQ : configuring mq server ..."

	rabbitmqadmin -q -u $1 -p $2 import $DIR_RESOURCES/rabbitmq-setup.json

	log "MQ : mq server configured ..."
}

run_mq_consume()
{
	declare typeof=$1
	declare throttle=$2


	log "MQ : launching consumer: "$typeof

	_run_mq_agent "consumer" $typeof $throttle
}

run_mq_consume_all()
{
	log "MQ : launching all consumers ..."

	for queue in "${MQ_QUEUES[@]}"
	do
		run_mq_consume $queue &
	done
}

run_mq_produce()
{
	declare typeof=$1
	declare throttle=$2
	declare misc=$3


	log "MQ : launching producer: "$typeof

	_run_mq_agent "producer" $typeof $throttle $misc
}

run_mq_purge()
{
	log "MQ : purging queues ..."

	for queue in "${MQ_QUEUES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-$queue
	done

	log "MQ : purged queues ..."
}

run_mq_reset()
{
	log "MQ : resetting server ..."

	for queue in "${MQ_QUEUES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer delete queue name=q-$queue
	done
	for user in "${MQ_USERS[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer delete user name=$user
	done
	for exchange in "${MQ_EXCHANGES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer delete exchange name=x-$exchange
	done
	for vhost in "${MQ_VHOSTS[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer delete vhost name=$vhost
	done

	log "MQ : reset server ..."
}

# Launch server.
run_mq_server()
{
	rabbitmq-server
}


