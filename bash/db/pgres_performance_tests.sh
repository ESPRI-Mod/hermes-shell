source $HERMES_HOME/bash/init.sh

log "DB : executing postgres db performance tests ..."

activate_venv server
python $HERMES_DIR_JOBS/db/run_pgres_performance_tests.py

log "DB : executed postgres db performance tests"
