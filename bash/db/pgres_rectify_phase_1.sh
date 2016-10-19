source $HERMES_HOME/bash/init.sh

log "DB : rectifying postgres db - phase 1 ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_rectify.sql

log "DB : rectifying postgres db - phase 1"
