#!/bin/bash

# ###############################################################
# SECTION: API
# ###############################################################

# Run api.
run_api()
{
    log "Launching API"

	activate_venv server

	python ./exec.py "run-api"
}