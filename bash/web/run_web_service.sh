# Import utils.
source $HERMES_HOME/bash/init.sh

log "Launching web service API"
activate_venv server
python $PRODIGUER_DIR_JOBS/web/run_web_service.py
