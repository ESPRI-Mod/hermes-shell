help_web_api()
{
	log "web-api"
	log "Description: launches web service API" 1
}

# Initializes WEB daemons.
help_web_daemons_init()
{
	log "web-daemons-init"
	log "Description: initializes Prodiguer daemon process controller" 1
}

# Kills WEB daemon process.
help_web_daemons_kill()
{
	log "web-daemons-kill"
	log "Description: stops Prodiguer WEB daemons & kills Prodiguer daemon process controller" 1
}

# Restarts WEB daemons.
help_web_daemons_refresh()
{
	log "web-daemons-refresh"
	log "Description: refreshes Prodiguer WEB daemons - i.e. reloads web-supervisor.conf & restarts" 1
}

# Restarts WEB daemons.
help_web_daemons_restart()
{
	log "web-daemons-restart"
	log "Description: restarts Prodiguer WEB daemons" 1
}

# Launches WEB daemons.
help_web_daemons_start()
{
	log "web-daemons-start"
	log "Description: starts Prodiguer WEB daemons" 1
}

# Launches WEB daemons.
help_web_daemons_status()
{
	log "web-daemons-status"
	log "Description: displays status of active Prodiguer WEB daemons" 1
}

# Launches WEB daemons.
help_web_daemons_stop()
{
	log "web-daemons-stop"
	log "Description: stops Prodiguer WEB daemons" 1
}

help_web()
{
	commands=(
		api
		daemons_init
		daemons_kill
		daemons_refresh
		daemons_restart
		daemons_start
		daemons_status
		daemons_stop
	)
	log_help_commands "web" ${commands[@]}
}
