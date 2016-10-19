source $HERMES_HOME/bash/init.sh

log "DB : rectifying postgres db ..."

activate_venv server
python $HERMES_HOME/bash/db/pgres_rectify.py --throttle=$1

log "DB : rectifying postgres db"
