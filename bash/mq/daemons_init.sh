# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Reset logs.
source $PRODIGUER_HOME/mq/daemons_reset_logs.sh

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : initialized daemons"
