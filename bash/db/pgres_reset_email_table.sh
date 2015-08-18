source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres mq.tbl_message_email table ..."

activate_venv server
python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_email_table.py

log "DB : reset postgres mq.tbl_message_email table ..."
