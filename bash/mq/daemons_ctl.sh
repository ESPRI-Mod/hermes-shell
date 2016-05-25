# Import utils.
source $HERMES_HOME/bash/init.sh

# Launch daemons.
activate_venv server
supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf
