source $HERMES_HOME/bash/init.sh

log "DB : creating database users"

createuser -U postgres -d -s prodiguer_db_admin
createuser -U prodiguer_db_admin -D -S -R prodiguer_db_user
