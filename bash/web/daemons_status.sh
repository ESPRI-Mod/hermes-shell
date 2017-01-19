# Import utils.
source $HERMES_HOME/bash/utils.sh

# Display daemon status.
activate_venv
supervisorctl -c $HERMES_DIR_DAEMONS/web/supervisord.conf status all
