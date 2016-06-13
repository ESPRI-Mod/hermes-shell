source $HERMES_HOME/bash/init.sh

log "DB : dropping database users"

dropuser -U hermes_db_admin hermes_db_mq_user
dropuser -U hermes_db_admin hermes_db_web_user
dropuser -U hermes_db_admin hermes_db_user
dropuser -U postgres hermes_db_admin
