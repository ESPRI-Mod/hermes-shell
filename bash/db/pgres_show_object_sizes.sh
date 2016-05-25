source $HERMES_HOME/bash/init.sh

log "DB : displaying postgres db object sizes ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_show_object_sizes.sql

log "DB : displayed postgres db object sizes ..."
