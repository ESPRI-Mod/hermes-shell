source $HERMES_HOME/bash/init.sh

log "DB : vacuuming postgres db ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_vacuum.sql

log "DB : vacuumed postgres db"
