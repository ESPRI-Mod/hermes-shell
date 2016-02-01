source $PRODIGUER_HOME/bash/init.sh

log "DB : truncating postgres conso tables ..."

psql -U prodiguer_db_admin -q -d prodiguer -f $PRODIGUER_HOME/bash/db/sql/pgres_truncate_conso.sql

log "DB : truncated postgres conso tables"