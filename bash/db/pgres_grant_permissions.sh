source $HERMES_HOME/bash/init.sh

log "DB : granting user permissions"

psql -U prodiguer_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_grant_permissions.sql
