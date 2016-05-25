source $HERMES_HOME/bash/init.sh

log "DB : dropping database users"

dropuser -U prodiguer_db_admin prodiguer_db_user
dropuser -U postgres prodiguer_db_admin
