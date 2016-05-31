source $HERMES_HOME/bash/init.sh

log "DB : migrating postgres db ..."

log "DB : creating new users"
source $HERMES_HOME/bash/db/pgres_create_db_users.sh
source $HERMES_HOME/bash/db/pgres_grant_permissions.sh

log "DB : renaming database"
psql -U hermes_db_admin -d postgres -q -f $HERMES_HOME/bash/db/sql/pgres_migrate-0-4-5-1.sql

log "DB : migrated postgres db"
