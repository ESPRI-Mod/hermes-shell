# Import utils.
source $HERMES_HOME/bash/utils.sh

# Reset supervisord log.
rm $HERMES_DIR_DAEMONS/web/supervisor.log

# Launch daemons.
activate_venv
supervisord -c $HERMES_DIR_DAEMONS/web/supervisord.conf

log "WEB : initialized daemons"
