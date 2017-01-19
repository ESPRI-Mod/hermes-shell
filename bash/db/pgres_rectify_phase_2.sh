source $HERMES_HOME/bash/utils.sh

log "DB : rectifying postgres db - phase 2 ..."

activate_venv
python $HERMES_HOME/bash/db/pgres_rectify_phase_2.py --throttle=$1

log "DB : rectified postgres db - phase 2"
