source $HERMES_HOME/bash/utils.sh

log "DB : creating database tables"

activate_venv
pushd $HERMES_HOME
pipenv run python $HERMES_DIR_JOBS/db/run_pgres_setup.py
popd
