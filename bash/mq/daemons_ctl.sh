# Import utils.
source $HERMES_HOME/bash/utils.sh

# Launch daemons.
activate_venv
supervisorctl -c $HERMES_DIR_DAEMONS/mq/supervisord.conf
