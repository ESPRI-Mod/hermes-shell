source $PRODIGUER_HOME/bash/init.sh

log "DB : resetting postgres cv.tbl_cv_term table ..."

activate_venv server
python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_cv_table.py

log "DB : reset postgres cv.tbl_cv_term table"
