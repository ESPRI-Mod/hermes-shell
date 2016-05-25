# Import utils.
source $HERMES_HOME/bash/init.sh

log "MQ : importing RabbitMQ broker definitions ..."

rabbitmqadmin -q -u prodiguer-mq-admin -p $1 import $HERMES_DIR_TEMPLATES/mq-rabbit-broker-definitions.json

log "MQ : imported RabbitMQ server broker definitions"

