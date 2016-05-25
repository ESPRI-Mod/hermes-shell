source $HERMES_HOME/bash/init.sh

log "DB : dropping database"

dropdb -U prodiguer_db_admin prodiguer
