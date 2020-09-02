source $HERMES_HOME/bash/utils.sh

log "DB : truncating postgres mq email stats table ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_mq_email_stats.sql

log "DB : truncated postgres mq email stats table"
