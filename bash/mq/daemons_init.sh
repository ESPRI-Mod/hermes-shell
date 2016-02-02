# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Reset message emails from db.
source $PRODIGUER_HOME/bash/db/pgres_truncate_mq_emails.sh

# Reset supervisord log.
rm $PRODIGUER_DIR_DAEMONS/mq/supervisor.log

# Launch daemons.
activate_venv server
supervisord -c $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf

log "MQ : initialized daemons"
