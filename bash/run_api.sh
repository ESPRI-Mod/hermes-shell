#!/bin/bash

# ###############################################################
# SECTION: API
# ###############################################################

# Run api.
run_api()
{
    log "Launching API"

	activate_venv server

	python $DIR_JOBS/api/run_api.py
}

# ###############################################################
# SECTION: API OPS
# ###############################################################

run_api_heartbeat()
{
	activate_venv server
	python $DIR_JOBS/api/ops/run_heartbeat.py
}

run_api_list_endpoints()
{
	activate_venv server
	python $DIR_JOBS/api/ops/run_list_endpoints.py
}

# ###############################################################
# SECTION: API MONITORING
# ###############################################################

run_monitor_simulation()
{
	activate_venv server
	python $DIR_JOBS/api/monitoring/run_monitor_simulation.py $1
}
