# Import utils.
source $HERMES_HOME/bash/init.sh

# Reset supervisord log.
rm $HERMES_DIR_DAEMONS/mq/supervisor.log

# Launch daemons.
activate_venv server
supervisord -c $HERMES_DIR_DAEMONS/mq/supervisord.conf

log "MQ : initialized daemons"
