# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Reset logs.
source $PRODIGUER_HOME/bash/mq/daemons_reset_logs.sh

# Reset message emails from db.
source $PRODIGUER_HOME/bash/db/pgres_reset_message_email_table.sh

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : initialized daemons"