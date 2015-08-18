# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Kill daemons.
activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf stop all
supervisorctl -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf shutdown

log "WEB : killed daemons"
