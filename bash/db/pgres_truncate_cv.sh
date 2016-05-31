source $HERMES_HOME/bash/init.sh

log "DB : truncating postgres cv tables ..."

psql -U hermes_db_admin -d prodiguer -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_cv.sql

activate_venv server
python $HERMES_DIR_JOBS/db/run_pgres_reset_cv_table.py

log "DB : truncated postgres cv tables"
