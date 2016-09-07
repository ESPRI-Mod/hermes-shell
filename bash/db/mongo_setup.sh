source $HERMES_HOME/bash/init.sh

log "DB : mongo db server set up starts ..."

mongo -u hermes-db-mongo-admin -p N@ture93! --authenticationDatabase admin admin $HERMES_HOME/bash/db/js/mongo_setup.js

log "DB : creating new users"

log "DB : mongo db server set up complete ..."
