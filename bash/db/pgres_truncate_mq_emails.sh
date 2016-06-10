source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres mq email table ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_mq_emails.sql

log "DB : truncated postgres mq email table"
