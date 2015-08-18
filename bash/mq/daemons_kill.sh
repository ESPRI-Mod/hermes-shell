# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Kill daemons.
activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf stop all
supervisorctl -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf shutdown

log "MQ : killed daemons"
