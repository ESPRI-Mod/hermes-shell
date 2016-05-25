# Import utils.
source $HERMES_HOME/bash/init.sh

log "Launching web service API"
activate_venv server
python $HERMES_DIR_JOBS/web/run_web_service.py
