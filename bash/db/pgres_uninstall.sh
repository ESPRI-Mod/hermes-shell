source $HERMES_HOME/bash/utils.sh

log "DB : uninstalling postgres db ..."

source $HERMES_HOME/bash/db/pgres_backup.sh
source $HERMES_HOME/bash/db/pgres_drop_db.sh
source $HERMES_HOME/bash/db/pgres_drop_db_users.sh

log "DB : uninstalled postgres db"
