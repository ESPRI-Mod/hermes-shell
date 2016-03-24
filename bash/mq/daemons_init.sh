# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Reset supervisord log.
rm $PRODIGUER_DIR_DAEMONS/mq/supervisor.log

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : initialized daemons"
