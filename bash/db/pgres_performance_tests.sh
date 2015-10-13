source $PRODIGUER_HOME/bash/init.sh

log "DB : running postgres db performance tests ..."

activate_venv server
python $PRODIGUER_DIR_JOBS/db/run_pgres_performance_tests.py

log "DB : migrated postgres db"
