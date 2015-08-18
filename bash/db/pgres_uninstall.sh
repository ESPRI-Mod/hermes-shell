source $PRODIGUER_HOME/bash/init.sh

log "DB : uninstalling postgres db ..."

source $PRODIGUER_HOME/db/pgres_backup.sh
source $PRODIGUER_HOME/db/pgres_drop_db.sh
source $PRODIGUER_HOME/db/pgres_drop_db_users.sh

log "DB : uninstalled postgres db"
