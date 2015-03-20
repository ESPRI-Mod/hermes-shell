help_db_mongo_start()
{
	log "db-mongo-start" 1
	log "starts mongodb daemon" 2
}

help_db_mongo_stop()
{
	log "db-mongo-stop" 1
	log "stops mongodb daemon" 2
}

help_db_mongo_restart()
{
	log "db-mongo-restart" 1
	log "restarts mongodb daemon" 2
}

help_db_mongo_install()
{
	log "db-mongo-install" 1
	log "installs mongodb" 2
}

help_db_pgres_backup()
{
	log "db-pgres-backup" 1
	log "performs a backup of database" 2
}

help_db_pgres_install()
{
	log "db-pgres-install" 1
	log "installs database intiialised with setup data" 2
}

help_db_pgres_reset()
{
	log "db-pgres-reset" 1
	log "uninstalls & installs database" 2
}

help_db_pgres_restore()
{
	log "db-pgres-restore" 1
	log "restores database from backup" 2
}

help_db_pgres_uninstall()
{
	log "db-pgres-uninstall" 1
	log "drops database" 2
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
		pgres_reset
		pgres_restore
		pgres_uninstall
	)
	log_help_commands "db" ${commands[@]}
}