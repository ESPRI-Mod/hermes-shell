source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres database ..."

run_db_pgres_uninstall
run_db_pgres_install

log "DB : reset postgres database"
