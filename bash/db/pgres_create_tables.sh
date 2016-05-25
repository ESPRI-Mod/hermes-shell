source $HERMES_HOME/bash/init.sh

log "DB : creating database tables"

activate_venv server
python $PRODIGUER_DIR_JOBS/db/run_pgres_setup.py
