# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

log "WEB : initialized daemons"
