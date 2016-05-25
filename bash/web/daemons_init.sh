# Import utils.
source $HERMES_HOME/bash/init.sh

# Reset supervisord log.
rm $PRODIGUER_DIR_DAEMONS/web/supervisor.log

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

log "WEB : initialized daemons"
