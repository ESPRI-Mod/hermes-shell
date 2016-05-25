# Import utils.
source $HERMES_HOME/bash/init.sh

# Display daemon status.
activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf status all
