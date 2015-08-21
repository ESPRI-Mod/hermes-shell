source $PRODIGUER_HOME/bash/init.sh

log "DB : creating database"

createdb -U prodiguer_db_admin -e -O prodiguer_db_admin -T template0 prodiguer
