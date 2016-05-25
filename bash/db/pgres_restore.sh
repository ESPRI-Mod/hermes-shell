source $HERMES_HOME/bash/init.sh

log "DB : restoring postgres db ..."

source $HERMES_HOME/bash/db/pgres_drop_db.sh
source $HERMES_HOME/bash/db/pgres_create_db.sh

declare backup_dir=$1

gzip -d $backup_dir/prodiguer.sql.gz
psql -U prodiguer_db_admin prodiguer -f $backup_dir/prodiguer.sql -q
gzip $backup_dir/prodiguer.sql

log "DB : restored postgres db"
