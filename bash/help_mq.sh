help_mq_configure()
{
	log "mq-configure" 1
	log "uploads RabbitMQ configuration file to RabbitMQ server" 2
}

help_mq_consume()
{
	log "mq-consume TYPE [THROTTLE]" 1
	log "runs a message consumer" 2
	log "TYPE = type of consumer to be run" 2
	log "THROTTLE = optional limit of number of messages to consume" 2
}

# Initializes MQ daemons.
help_mq_daemons_init()
{
	log "mq-daemons-init" 1
	log "initializes Prodiguer daemon process controller" 2
}

# Kills MQ daemon process.
help_mq_daemons_kill()
{
	log "mq-daemons-kill" 1
	log "stops Prodiguer MQ daemons & kills Prodiguer daemon process controller" 2
}

# Restarts MQ daemons.
help_mq_daemons_refresh()
{
	log "mq-daemons-refresh" 1
	log "refreshes Prodiguer MQ daemons - i.e. reloads mq-supervisor.conf & restarts" 2
}

# Restarts MQ daemons.
help_mq_daemons_restart()
{
	log "mq-daemons-restart" 1
	log "restarts Prodiguer MQ daemons" 2
}

# Launches MQ daemons.
help_mq_daemons_start()
{
	log "mq-daemons-start" 1
	log "starts Prodiguer MQ daemons" 2
}

# Launches MQ daemons.
help_mq_daemons_status()
{
	log "mq-daemons-status" 1
	log "displays status of active Prodiguer MQ daemons" 2
}

# Launches MQ daemons.
help_mq_daemons_stop()
{
	log "mq-daemons-stop" 1
	log "stops Prodiguer MQ daemons" 2
}


help_mq_produce()
{
	log "mq-produce TYPE [THROTTLE]" 1
	log "runs a message producer" 2
	log "TYPE = type of producer to be run" 2
	log "THROTTLE = optional limit of number of messages to produce" 2
}

help_mq_purge()
{
	log "mq-purge" 1
	log "deletes all messages from all queues" 2
}

help_mq_reset()
{
	log "mq-reset" 1
	log "deletes all vhosts, exhanges, queues and users from RabbitMQ server" 2
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
		reset
	)
	log_help_commands "mq" ${commands[@]}
}
