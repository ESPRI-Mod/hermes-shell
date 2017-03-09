source $HERMES_HOME/bash/utils.sh

log "DB : deleting simulation "$1" from db ..."

activate_venv
python $HERMES_HOME/bash/db/pgres_delete_simulation.py --uid=$1

log "DB : simulation deleted "$1" from db ..."
