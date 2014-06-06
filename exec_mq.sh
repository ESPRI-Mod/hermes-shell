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
