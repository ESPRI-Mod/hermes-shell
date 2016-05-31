source $HERMES_HOME/bash/init.sh

log "DB : restoring postgres db ..."

source $HERMES_HOME/bash/db/pgres_drop_db.sh
source $HERMES_HOME/bash/db/pgres_create_db.sh

declare backup_dir=$1

gzip -d $backup_dir/$HERMES_PGRES_DB_NAME.sql.gz
psql -U hermes_db_admin $HERMES_PGRES_DB_NAME -f $backup_dir/$HERMES_PGRES_DB_NAME.sql -q
gzip $backup_dir/$HERMES_PGRES_DB_NAME.sql

log "DB : restored postgres db"
