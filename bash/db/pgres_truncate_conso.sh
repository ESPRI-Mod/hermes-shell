source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres conso tables ..."

psql -U hermes_db_admin -q -d $HERMES_DB_PGRES_NAME -f $HERMES_HOME/bash/db/sql/pgres_truncate_conso.sql

log "DB : truncated postgres conso tables"