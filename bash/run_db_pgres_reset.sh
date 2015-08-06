#!/bin/bash

# ###############################################################
# SECTION: DB RESET FUNCTIONS
# ###############################################################

# Reset db.
run_db_pgres_reset()
{
	log "DB : resetting postgres db ..."

	run_db_pgres_uninstall
	run_db_pgres_install

	log "DB : reset postgres db"
}

# Reset table: cv.tbl_cv_term table
run_db_pgres_reset_cv_table()
{
	log "DB : resetting postgres cv.tbl_cv_term table ..."

	activate_venv server
	python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_cv_table.py

	log "DB : reset postgres cv.tbl_cv_term table ..."
}

# Reset table: monitoring.tbl_message_email
run_db_pgres_reset_email_table()
{
	log "DB : resetting postgres mq.tbl_message_email table ..."

	activate_venv server
	python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_email_table.py

	log "DB : reset postgres mq.tbl_message_email table ..."
}

# Reset table: monitoring.tbl_message
run_db_pgres_reset_message_table()
{
	log "DB : resetting postgres mq.message table ..."

	activate_venv server
	python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_message_table.py

	log "DB : reset postgres mq.message table ..."
}

# Reset table: monitoring.tbl_environment_metric
run_db_pgres_reset_environment_metric_table()
{
	log "DB : resetting postgres mq.message table ..."

	activate_venv server
	python $PRODIGUER_DIR_JOBS/db/run_pgres_reset_env_metrics_table.py

	log "DB : reset postgres mq.message table ..."
}
