# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Launch daemons.
activate_venv server
supervisorctl -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
