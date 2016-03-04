# Import utils.
source $PRODIGUER_HOME/bash/init.sh

log "Sending a test monitoring event"
activate_venv server
python $PRODIGUER_DIR_JOBS/web/test_monitoring_event.py -mt=$1 -sim=$2 -job=$3

