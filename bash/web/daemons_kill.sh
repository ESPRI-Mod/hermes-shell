# Import utils.
source $HERMES_HOME/bash/init.sh

# Kill daemons.
activate_venv server
supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf stop all
supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf shutdown

log "WEB : killed daemons"
