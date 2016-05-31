source $HERMES_HOME/bash/init.sh

log "DB : migrating postgres db ..."

psql -U hermes_db_admin -d $HERMES_PGRES_DB_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_migrate-0-4-4-2.sql
source $HERMES_HOME/bash/db/pgres_grant_permissions.sh

log "DB : migrated postgres db"
