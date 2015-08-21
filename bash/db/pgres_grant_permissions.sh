source $PRODIGUER_HOME/bash/init.sh

log "DB : granting user permissions"

psql -U prodiguer_db_admin -d prodiguer -q -f $PRODIGUER_HOME/bash/db/pgres_grant_permissions.sql
