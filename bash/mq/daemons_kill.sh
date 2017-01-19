# Import utils.
source $HERMES_HOME/bash/utils.sh

# Kill daemons.
activate_venv
supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf stop all
supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf shutdown

log "MQ : killed daemons"
