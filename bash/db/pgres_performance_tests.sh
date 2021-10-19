source $HERMES_HOME/bash/utils.sh

log "DB : executing postgres db performance tests ..."

activate_venv
pushd $HERMES_HOME
pipenv run python $HERMES_DIR_JOBS/db/run_pgres_performance_tests.py
popd

log "DB : executed postgres db performance tests"
