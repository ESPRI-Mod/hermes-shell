source $PRODIGUER_HOME/bash/init.sh

log "DB : installing postgres db ..."

source $PRODIGUER_HOME/db/pgres_create_db_users.sh
source $PRODIGUER_HOME/db/pgres_create_db.sh
source $PRODIGUER_HOME/db/pgres_create_tables.sh
source $PRODIGUER_HOME/db/pgres_grant_permissions.sh

log "DB : installed postgres db"
