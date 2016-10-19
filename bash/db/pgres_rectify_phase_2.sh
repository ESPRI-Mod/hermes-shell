source $HERMES_HOME/bash/init.sh

log "DB : rectifying postgres db - phase 2 ..."

activate_venv server
python $HERMES_HOME/bash/db/pgres_rectify_phase_2.py --throttle=$1

log "DB : rectifying postgres db - phase 2"
