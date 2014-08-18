#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Launch server.
run_mq_server()
{
	rabbitmq-server
}

run_mq_purge_queues()
{
	log "MQ : purging queues ..."

	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-ext-log
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-ext-smtp
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-in-log
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-in-persist
	rabbitmqadmin -q -u $1 -p $2 -V prodiguer purge queue name=q-internal-monitoring

	log "MQ : purged queues ..."
}

run_mq_producer()
{
	declare typeof=$1

	log "MQ : launching $typeof MQ producer ..."

    activate_venv server
	python $DIR_SCRIPTS/jobs/run_mq_producer_$typeof.py

	log "MQ : launched $typeof MQ producer ..."
}

run_mq_consumer()
{
	declare typeof=$1
	declare limit=$2

	log "MQ : launching $typeof MQ consumer ..."

    activate_venv server
	python $DIR_SCRIPTS/jobs/run_mq_consumer_$typeof.py $limit

	log "MQ : launched $typeof MQ consumer ..."
}

run_mq_to_api()
{
	log "TODO"
}
