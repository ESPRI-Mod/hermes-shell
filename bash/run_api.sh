#!/bin/bash

# ###############################################################
# SECTION: API
# ###############################################################

# Run api.
run_api()
{
    log "Launching API"

	activate_venv server

	python $DIR_SCRIPTS/jobs/run_web_api.py
}

# ###############################################################
# SECTION: API METRIC
# ###############################################################

_exec_metric_api()
{
	activate_venv server
	python $DIR_SCRIPTS/jobs/run_web_api_metric.py $1 $2 $3
}

# Add metrics.
run_metric_add()
{
	_exec_metric_api "add" $1
}

# Delete metric group.
run_metric_delete_group()
{
	_exec_metric_api "delete-group" $1
}

# Delete metric lines.
run_metric_delete_line()
{
	_exec_metric_api "delete-line" $1
}

# Fetch metric group.
run_metric_fetch()
{
	_exec_metric_api "fetch" $1 $2
}

# Fetch metric group line count.
run_metric_fetch_line_count()
{
	_exec_metric_api "fetch-line-count" $1
}

# Fetch metric group headers.
run_metric_fetch_headers()
{
	_exec_metric_api "fetch-headers" $1
}

# List groups.
run_metric_list_group()
{
	_exec_metric_api "list-group"
}