source $HERMES_HOME/bash/utils.sh

log "DB : truncating postgres mq message table ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_mq_messages.sql

log "DB : truncated postgres mq message table"
