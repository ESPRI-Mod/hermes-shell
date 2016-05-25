source $HERMES_HOME/bash/init.sh

log "DB : installing postgres db ..."

source $HERMES_HOME/bash/db/pgres_create_db_users.sh
source $HERMES_HOME/bash/db/pgres_create_db.sh
source $HERMES_HOME/bash/db/pgres_create_tables.sh
source $HERMES_HOME/bash/db/pgres_grant_permissions.sh

log "DB : installed postgres db"
