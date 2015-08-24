# Import utils.
source $PRODIGUER_HOME/bash/init.sh

log "MQ : configuring RabbitMQ server ..."

rabbitmqadmin -q -u $1 -p $2 import $PRODIGUER_DIR_TEMPLATES/mq-rabbit.json

log "MQ : RabbitMQ server configured"
