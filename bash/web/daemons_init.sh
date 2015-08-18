# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Reset logs.
source $PRODIGUER_HOME/web/daemons_reset_logs.sh

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

log "WEB : initialized daemons"
