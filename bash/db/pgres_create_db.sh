source $HERMES_HOME/bash/init.sh

log "DB : creating database"

createdb -U hermes_db_admin -e -O hermes_db_admin -T template0 prodiguer
