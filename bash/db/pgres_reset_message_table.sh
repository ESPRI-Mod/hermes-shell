source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres mq.message table ..."

activate_venv server
python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_message_table.py

log "DB : reset postgres mq.message table ..."
