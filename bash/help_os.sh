help_os_setup()
{
	log "os-setup OS-TYPE SERVER-TYPE"
	log "Description: sets up an operating system so that the Prodiguer stack can be installed" 1
	log "OS-TYPE: type of operating system being configured" 1
	log "SERVER-TYPE: type of server being configured" 1
}

help_os()
{
	commands=(
		setup
	)
	log_help_commands "os" ${commands[@]}
}
