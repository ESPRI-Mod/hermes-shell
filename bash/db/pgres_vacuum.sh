source $HERMES_HOME/bash/utils.sh

log "DB : vacuuming postgres db ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_vacuum.sql

log "DB : vacuumed postgres db"
