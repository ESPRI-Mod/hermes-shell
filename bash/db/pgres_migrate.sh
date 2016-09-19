source $HERMES_HOME/bash/init.sh

log "DB : migrating postgres db ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_migrate-1-0-3-0-4.sql
source $HERMES_HOME/bash/db/pgres_grant_permissions.sh

log "DB : migrated postgres db"
