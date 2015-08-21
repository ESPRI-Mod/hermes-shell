source $PRODIGUER_HOME/bash/init.sh

log "DB : migrating postgres db ..."

source $PRODIGUER_HOME/bash/db/pgres_backup.sh
psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/db/pgres_migrate.sql
source $PRODIGUER_HOME/bash/db/pgres_grant_permissions.sh

log "DB : migrated postgres db"
