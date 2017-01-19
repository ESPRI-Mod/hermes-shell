# Import utils.
source $HERMES_HOME/bash/utils.sh

log "MQ : stopping live-smtp-realtime email listener ..."

activate_venv
supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf stop live-smtp-realtime:01

log "MQ : stopped live-smtp-realtime email listener ..."
