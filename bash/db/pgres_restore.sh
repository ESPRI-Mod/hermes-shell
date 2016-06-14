source $HERMES_HOME/bash/init.sh

log "DB : restoring postgres db ..."

source $HERMES_HOME/bash/db/pgres_drop_db.sh
source $HERMES_HOME/bash/db/pgres_create_db.sh

declare backup_dir=$1
psql -U hermes_db_admin $HERMES_DB_PGRES_NAME -f $backup_dir/$HERMES_DB_PGRES_NAME.sql -q

log "DB : restored postgres db"
