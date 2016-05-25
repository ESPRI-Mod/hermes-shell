source $HERMES_HOME/bash/init.sh

log "DB : creating test postgres db ..."

activate_venv server
python $HERMES_DIR_JOBS/db/run_pgres_create_test_db.py

log "DB : created test postgres db"
