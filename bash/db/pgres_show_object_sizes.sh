source $HERMES_HOME/bash/init.sh

log "DB : displaying postgres db object sizes ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_show_object_sizes.sql

log "DB : displayed postgres db object sizes ..."
