# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Replace supervisord configuarion.
cp $PRODIGUER_DIR_TEMPLATES/config/mq-supervisord-debug.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : updated daemons config for debugging"
