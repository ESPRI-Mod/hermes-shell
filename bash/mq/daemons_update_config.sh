# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Replace supervisord configuarion.
cp $PRODIGUER_DIR_TEMPLATES/mq-supervisord.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : updated daemons config"
