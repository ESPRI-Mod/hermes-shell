source $HERMES_HOME/bash/utils.sh

log "DB : rectifying postgres db ..."

activate_venv
pushd $HERMES_HOME
pipenv run python $HERMES_HOME/bash/db/pgres_rectify.py --throttle=$1
popd

log "DB : rectified postgres db"
