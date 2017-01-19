source $HERMES_HOME/bash/utils.sh

log "DB : creating database tables"

activate_venv
python $HERMES_DIR_JOBS/db/run_pgres_setup.py
