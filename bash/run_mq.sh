#!/bin/bash

# ###############################################################
# SECTION: MQ FUNCTIONS
# ###############################################################

# Launch server.
run_mq()
{
	log "MQ : launching Rabbit-MQ server ..."

	rabbitmq-server

	log "MQ : launched Rabbit-MQ server ..."
}

run_mq_consumer()
{
	log "MQ : launching MQ consumer ..."

    activate_venv server

	if [ $1 = "smtp" ]; then
	    log "MQ: launching SMTP consumer ..."
    	python $DIR_OPS_SCRIPTS/run_mq_consumer_smtp.py
    fi

	log "MQ : launched MQ consumer ..."
}

run_mq_to_api()
{
	log "MQ : launching MQ consumer ..."

    activate_venv server

	if [ $1 = "smtp" ]; then
	    log "MQ: launching SMTP consumer ..."
    	python $DIR_OPS_SCRIPTS/run_mq_consumer_smtp.py
    fi

	log "MQ : launched MQ consumer ..."
}
