source $HERMES_HOME/bash/utils.sh

log "DB : rectifying postgres db ..."

activate_venv
python $HERMES_HOME/bash/db/pgres_rectify.py --throttle=$1

log "DB : rectified postgres db"
