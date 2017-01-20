#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	log "MQ : importing RabbitMQ broker definitions ..."
	rabbitmqadmin -q -u hermes-mq-admin -p $1 import $HERMES_DIR_TEMPLATES/mq-rabbit-broker-definitions.json
	log "MQ : imported RabbitMQ server broker definitions"
}

# Invoke entry point.
main $1