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
	'ext-smtp'
	'in-monitoring'
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
	'internal-sms'
	'internal-smtp'
)

# Set of dead MQ queues.
declare -a MQ_DEAD_QUEUES=(
	'ext-log'
	'in-log'
)

_run_mq_agent()
{
	declare agent=$1
	declare typeof=$2
	declare throttle=$3
	declare misc=$4

    activate_venv server
	python $DIR_JOBS"/mq/"$agent $typeof $throttle $misc
}

run_mq_configure()
{
	log "MQ : configuring mq server ..."

	rabbitmqadmin -q -u $1 -p $2 import $DIR_TEMPLATES/config/rabbitmq.json

	log "MQ : mq server configured ..."
}

run_mq_consume()
{
	declare typeof=$1
	declare throttle=$2

	log "MQ : launching consumer: "$typeof

    activate_venv server
	python $DIR_JOBS"/mq/consumer" --agent-type=$typeof --agent-limit=$throttle
}

run_mq_produce()
{
	declare typeof=$1
	declare throttle=$2
	declare misc=$3

	log "MQ : launching producer: "$typeof

    activate_venv server
	python $DIR_JOBS"/mq/producer" --agent-type=$typeof --agent-limit=$throttle --agent-arg=$misc
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

	# Drop existing.
	for queue in "${MQ_DEAD_QUEUES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer delete queue name=q-$queue
	done
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

	# Reconfigure.
	run_mq_configure $1 $2

	log "MQ : reset server ..."
}

# Initializes MQ daemons.
run_mq_daemons_init()
{
    activate_venv server

    supervisord -c $DIR_CONFIG/mq-supervisord.conf
}

# Restarts MQ daemons.
run_mq_daemons_refresh()
{
    activate_venv server

    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf stop all
    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf update all
    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf start all
}

# Restarts MQ daemons.
run_mq_daemons_restart()
{
    activate_venv server

    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf stop all
    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf start all
}

# Launches MQ daemons.
run_mq_daemons_start()
{
    activate_venv server

    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf start all
}

# Launches MQ daemons.
run_mq_daemons_status()
{
    activate_venv server

    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf status all
}

# Launches MQ daemons.
run_mq_daemons_stop()
{
    activate_venv server

    supervisorctl -c $DIR_CONFIG/mq-supervisord.conf stop all
}
