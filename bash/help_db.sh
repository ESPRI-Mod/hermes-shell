help_db_mongo_start()
{
	log "db-mongo-start"
	log "Description: starts mongodb daemon" 1
}

help_db_mongo_stop()
{
	log "db-mongo-stop"
	log "Description: stops mongodb daemon" 1
}

help_db_mongo_restart()
{
	log "db-mongo-restart"
	log "Description: restarts mongodb daemon" 1
}

help_db_mongo_install()
{
	log "db-mongo-install"
	log "Description: installs mongodb" 1
}

help_db_pgres_backup()
{
	log "db-pgres-backup"
	log "Description: performs a backup of database" 1
}

help_db_pgres_install()
{
	log "db-pgres-install"
	log "Description: installs database intiialised with setup data" 1
}

help_db_pgres_migrate()
{
	log "db-pgres-migrate"
	log "Description: migrates database to latest schema version" 1
}

help_db_pgres_reset()
{
	log "db-pgres-reset"
	log "Description: uninstalls & installs database" 1
}

help_db_pgres_cv_table_reset()
{
	log "db-pgres-cv-table-reset"
	log "Description: resets the controlled vocabulary table after terms have been manually updated" 1
}

help_db_pgres_restore()
{
	log "db-pgres-restore BACKUP_DIR"
	log "Description: restores database from backup" 1
	log "BACKUP_DIR = directory within which backup files are located" 1
}

help_db_pgres_uninstall()
{
	log "db-pgres-uninstall"
	log "Description: drops database" 1
}

help_db()
{
	commands=(
		mongo_start
		mongo_stop
		mongo_restart
		mongo_install
		pgres_backup
		pgres_install
		pgres_migrate
		pgres_reset
		pgres_reset_cv_table
		pgres_restore
		pgres_uninstall
	)
	log_help_commands "db" ${commands[@]}
}