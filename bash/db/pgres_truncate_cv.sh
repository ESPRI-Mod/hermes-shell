source $HERMES_HOME/bash/utils.sh

log "DB : truncating postgres cv tables ..."

psql -U hermes_db_admin -d $HERMES_DB_PGRES_NAME -q -f $HERMES_HOME/bash/db/sql/pgres_truncate_cv.sql

activate_venv
pushd $HERMES_HOME
pipenv run python $HERMES_DIR_JOBS/db/run_pgres_reset_cv_table.py
popd

log "DB : truncated postgres cv tables"
