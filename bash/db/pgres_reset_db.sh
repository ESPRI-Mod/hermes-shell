source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres database ..."

source $PRODIGUER_HOME/bash/db/pgres_uninstall.sh
source $PRODIGUER_HOME/bash/db/pgres_install.sh

log "DB : reset postgres database"
