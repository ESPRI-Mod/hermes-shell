source $PRODIGUER_HOME/bash/init.sh

log "DB : truncating postgres mq tables ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/bash/db/sql/pgres_truncate_mq.sql

log "DB : truncated postgres mq tables"
