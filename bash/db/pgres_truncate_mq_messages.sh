source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres mq message table ..."

psql -U hermes_db_admin -d $HERMES_PGRES_DB_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_mq_messages.sql

log "DB : truncated postgres mq message table"
