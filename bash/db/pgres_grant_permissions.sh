source $HERMES_HOME/bash/utils.sh

log "DB : granting user permissions"

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_grant_permissions.sql
