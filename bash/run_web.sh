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
