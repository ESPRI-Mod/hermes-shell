source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres monitoring tables ..."

psql -U hermes_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_monitoring.sql

log "DB : truncated postgres monitoring tables"
