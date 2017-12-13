source $HERMES_HOME/bash/utils.sh

log "DB : killing postgres db ..."

source $HERMES_HOME/bash/db/pgres_drop_db.sh
source $HERMES_HOME/bash/db/pgres_drop_db_users.sh

log "DB : killed postgres db"
