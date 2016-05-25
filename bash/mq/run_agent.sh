# Import utils.
source $HERMES_HOME/bash/init.sh

# Run job.
activate_venv server
python $HERMES_DIR_JOBS"/mq" --agent-type=$1 --agent-limit=$2
