source $HERMES_HOME/bash/init.sh

log "DB : dropping database"

dropdb -U hermes_db_admin $HERMES_DB_PGRES_NAME
