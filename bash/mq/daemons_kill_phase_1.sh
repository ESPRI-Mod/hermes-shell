# Import utils.
source $HERMES_HOME/bash/init.sh

log "MQ : stopping live-smtp-realtime email listener ..."

activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf stop live-smtp-realtime:01

log "MQ : stopped live-smtp-realtime email listener ..."
