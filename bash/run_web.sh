#!/bin/bash

# ###############################################################
# SECTION: API OPS
# ###############################################################

# Run api.
run_web_api()
{
    log "Launching API"

	activate_venv server

	python $DIR_JOBS/api/run_api.py
}

run_web_api_heartbeat()
{
	activate_venv server
	python $DIR_JOBS/api/ops/run_heartbeat.py
}

run_web_api_list_endpoints()
{
	activate_venv server
	python $DIR_JOBS/api/ops/run_list_endpoints.py
}
