source $PRODIGUER_HOME/bash/init.sh

log "DB : migrating postgres db ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/bash/db/sql/pgres_migrate-0-4-3-1.sql
source $PRODIGUER_HOME/bash/db/pgres_grant_permissions.sh

log "DB : migrated postgres db"
