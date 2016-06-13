source $HERMES_HOME/bash/init.sh

log "DB : creating database users"

createuser -U postgres -d -s hermes_db_admin
createuser -U hermes_db_admin -D -S -R hermes_db_user
createuser -U hermes_db_admin -D -S -R hermes_db_web_user
createuser -U hermes_db_admin -D -S -R hermes_db_mq_user
