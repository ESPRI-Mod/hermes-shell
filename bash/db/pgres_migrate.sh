source $PRODIGUER_HOME/bash/init.sh

log "DB : migrating postgres db ..."

psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/bash/db/pgres_migrate-0-4-1-0.sql
source $PRODIGUER_HOME/bash/db/pgres_grant_permissions.sh

log "DB : migrated postgres db"
