source $HERMES_HOME/bash/utils.sh

log "DB : creating test postgres db ..."

activate_venv
pushd $HERMES_HOME
pipenv run python $HERMES_DIR_JOBS/db/run_pgres_create_test_db.py
popd

log "DB : created test postgres db"
