# Import utils.
source $HERMES_HOME/bash/init.sh

# Replace supervisord configuarion.
cp $HERMES_DIR_TEMPLATES/mq-supervisord.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf

log "MQ : updated daemons config"
