source $HERMES_HOME/bash/utils.sh

log "DB : resetting postgres database ..."

source $HERMES_HOME/bash/db/pgres_uninstall.sh
source $HERMES_HOME/bash/db/pgres_install.sh

log "DB : reset postgres database"
