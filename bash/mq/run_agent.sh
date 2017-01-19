# Import utils.
source $HERMES_HOME/bash/utils.sh

# Run job.
activate_venv
python $HERMES_DIR_JOBS"/mq" --agent-type=$1 --agent-limit=$2
