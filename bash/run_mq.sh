#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Set of supported MQ queues.
declare -a MQ_QUEUES=(
	'ext-smtp'
	'in-metrics-env'
	'in-metrics-sim'
	'in-monitoring-compute'
	'in-monitoring-post-processing'
	'internal-api'
	'internal-cv'
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

# Set of supported debug MQ queues.
declare -a MQ_DEBUG_QUEUES=(
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

_run_mq_agent()
{
    activate_venv server
	python $DIR_JOBS"/mq" --agent-type=$1 --agent-limit=$2
}

run_mq_configure()
{
	log "MQ : configuring mq server ..."

	rabbitmqadmin -q -u $1 -p $2 import $DIR_TEMPLATES/config/mq-rabbit.json

	log "MQ : mq server configured ..."
}

run_mq_consume()
{
	log "MQ : launching consumer: "$1
	_run_mq_agent $1 $2
}

run_mq_produce()
{
	log "MQ : launching producer: "$1
	_run_mq_agent $1 $2
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

run_mq_purge_debug_queues()
{
	log "MQ : purging debug queues ..."

	for queue in "${MQ_DEBUG_QUEUES[@]}"
	do
		rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-$queue
	done

	log "MQ : purged debug queues ..."
}

# Resets MQ daemon logs.
run_mq_daemons_reset_logs()
{
	rm $DIR_LOGS/mq/*.log
	rm $DIR_DAEMONS/mq/supervisord.log
}

# Initializes MQ daemons.
run_mq_daemons_init()
{
	run_mq_daemons_reset_logs

    activate_venv server

    supervisord -c $DIR_DAEMONS/mq/supervisord.conf
}

# Kills MQ daemon process.
run_mq_daemons_kill()
{
    activate_venv server

 	 supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf stop all
     supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf shutdown
}

# Restarts MQ daemons.
run_mq_daemons_refresh()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf update all
    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf start all
}

# Restarts MQ daemons.
run_mq_daemons_restart()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf start all
}

# Launches MQ daemons.
run_mq_daemons_start()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf start all
}

# Launches MQ daemons.
run_mq_daemons_status()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf status all
}

# Launches MQ daemons.
run_mq_daemons_stop()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/mq/supervisord.conf stop all
}

# Updates the mq supervisord config file.
run_mq_daemons_update_config()
{
	cp $DIR_TEMPLATES/config/mq-supervisord.conf $DIR_DAEMONS/mq/supervisord.conf
}

# Updates the mq supervisord config file (for debugging).
run_mq_daemons_update_config_for_debug()
{
	cp $DIR_TEMPLATES/config/mq-supervisord-debug.conf $DIR_DAEMONS/mq/supervisord.conf
}
