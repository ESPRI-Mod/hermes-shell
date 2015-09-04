# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Replace supervisord configuarion.
if [ $PRODIGUER_MACHINE_TYPE = "dev" ]; then
	cp $PRODIGUER_DIR_TEMPLATES/mq-supervisord-dev.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
elif [ $PRODIGUER_MACHINE_TYPE = "mq" ]; then
	cp $PRODIGUER_DIR_TEMPLATES/mq-supervisord-mq.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
fi

log "MQ : updated daemons config"
