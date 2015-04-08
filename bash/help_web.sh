help_web_api()
{
	log "web-api"
	log "Description: launches web service API" 1
}

help_web()
{
	commands=(
		api
	)
	log_help_commands "web" ${commands[@]}
}
