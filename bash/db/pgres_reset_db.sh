source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres database ..."

prodiguer-db-pgres-uninstall
prodiguer-db-pgres-install

log "DB : reset postgres database"
