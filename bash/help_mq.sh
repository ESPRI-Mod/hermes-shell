help_mq_configure()
{
	log "mq-configure"
	log "Description: uploads RabbitMQ configuration file to RabbitMQ server" 1
}

help_mq_consume()
{
	log "mq-consume TYPE [THROTTLE]"
	log "Description: runs a message consumer" 1
	log "TYPE = type of consumer to be run" 1
	log "THROTTLE = optional limit of number of messages to consume" 1
}

# Initializes MQ daemons.
help_mq_daemons_init()
{
	log "mq-daemons-init"
	log "Description: initializes Prodiguer daemon process controller" 1
}

# Kills MQ daemon process.
help_mq_daemons_kill()
{
	log "mq-daemons-kill"
	log "Description: stops Prodiguer MQ daemons & kills Prodiguer daemon process controller" 1
}

# Restarts MQ daemons.
help_mq_daemons_refresh()
{
	log "mq-daemons-refresh"
	log "Description: refreshes Prodiguer MQ daemons - i.e. reloads mq-supervisor.conf & restarts" 1
}

# Restarts MQ daemons.
help_mq_daemons_restart()
{
	log "mq-daemons-restart"
	log "Description: restarts Prodiguer MQ daemons" 1
}

# Launches MQ daemons.
help_mq_daemons_start()
{
	log "mq-daemons-start"
	log "Description: starts Prodiguer MQ daemons" 1
}

# Launches MQ daemons.
help_mq_daemons_status()
{
	log "mq-daemons-status"
	log "Description: displays status of active Prodiguer MQ daemons" 1
}

# Launches MQ daemons.
help_mq_daemons_stop()
{
	log "mq-daemons-stop"
	log "Description: stops Prodiguer MQ daemons" 1
}

help_mq_produce()
{
	log "mq-produce TYPE [THROTTLE]"
	log "Description: runs a message producer" 1
	log "TYPE = type of producer to be run" 1
	log "THROTTLE = optional limit of number of messages to produce" 1
}

help_mq_purge()
{
	log "mq-purge"
	log "Description: deletes all messages from all queues" 1
}

help_mq()
{
	commands=(
		configure
		consume
		daemons_init
		daemons_kill
		daemons_refresh
		daemons_restart
		daemons_start
		daemons_status
		daemons_stop
		produce
		purge
	)
	log_help_commands "mq" ${commands[@]}
}
