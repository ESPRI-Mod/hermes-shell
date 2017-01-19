# Import utils.
source $HERMES_HOME/bash/utils.sh

log "Sending a test monitoring event"
activate_venv
python $HERMES_DIR_JOBS/web/test_monitoring_event.py -mt=$1 -sim=$2 -job=$3

