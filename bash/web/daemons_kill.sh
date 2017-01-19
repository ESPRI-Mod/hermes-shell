# Import utils.
source $HERMES_HOME/bash/utils.sh

# Kill daemons.
activate_venv
supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf stop all
supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf shutdown

log "WEB : killed daemons"
