source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres mq email table ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_mq_emails.sql

log "DB : truncated postgres mq email table"
