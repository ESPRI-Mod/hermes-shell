source $PRODIGUER_HOME/bash/init.sh

log "DB : vacuuming (full) postgres db ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/bash/db/sql/pgres_vacuum_full.sql

log "DB : vacuumed (full) postgres db"