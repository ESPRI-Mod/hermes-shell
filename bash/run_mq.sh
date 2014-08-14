#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Launch server.
run_mq_server()
{
	rabbitmq-server
}

_run_mq_producer()
{
	log "MQ : launching $1 MQ producer ..."

    activate_venv server
	python $DIR_SCRIPTS/jobs/run_mq_producer_$1.py

	log "MQ : launched $1 MQ producer ..."
}

_run_mq_consumer()
{
	log "MQ : launching $1 MQ consumer ..."

    activate_venv server
	python $DIR_SCRIPTS/jobs/run_mq_consumer_$1.py

	log "MQ : launched $1 MQ consumer ..."
}

run_mq_producer_smtp()
{
	_run_mq_producer "smtp"
}

run_mq_consumer_persist()
{
	_run_mq_consumer "persist"
}

run_mq_to_api()
{
	log "TODO"
}
