# Import utils.
source $HERMES_HOME/bash/init.sh

# Launch daemons.
activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/web/supervisord.conf
