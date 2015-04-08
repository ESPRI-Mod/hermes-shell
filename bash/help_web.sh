help_web_api()
{
	log "web-api"
	log "Description: launches web service API" 1
}

help_web_api_heartbeat()
{
	log "web-api-heartbeat"
	log "Description: indicates whether web service API is up and running" 1
}

help_web_api_list_endpoints()
{
	log "web-api-list-endpoints"
	log "Description: displays list of endpoints supported by web service API" 1
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
