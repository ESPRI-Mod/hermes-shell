# Import utils.
source $HERMES_HOME/bash/utils.sh

# Replace supervisord configuarion.
cp $HERMES_DIR_TEMPLATES/mq-supervisord-$HERMES_DEPLOYMENT_MODE.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf

log "MQ : updated daemons config"
