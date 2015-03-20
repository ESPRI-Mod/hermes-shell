help_web_api()
{
	log "web-api" 1
	log "launches web service API" 2
}

help_web_api_heartbeat()
{
	log "web-api-heartbeat" 1
	log "indicates whether web service API is up and running" 2
}

help_web_api_list_endpoints()
{
	log "web-api-list-endpoints" 1
	log "displays list of endpoints supported by web service API" 2
}

help_web()
{
	commands=(
		api
		api_heartbeat
		api_list_endpoints
	)
	log_help_commands "web" ${commands[@]}
}
