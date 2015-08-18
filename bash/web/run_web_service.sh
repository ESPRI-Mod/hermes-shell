# Import utils.
source $PRODIGUER_HOME/bash/init.sh

log "Launching web service API"
activate_venv server
python $PRODIGUER_DIR_JOBS/web/run_api.py
