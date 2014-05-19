#!/bin/bash

# ###############################################################
# SECTION: API METRIC
# ###############################################################

_exec_metric_api()
{
	activate_venv server
	python ./exec_api_metric.py $1 $2 $3
}

# Add metrics.
metric_add()
{
	_exec_metric_api "add" $1
}

# Delete metric group.
metric_delete_group()
{
	_exec_metric_api "delete-group" $1
}

# Delete metric lines.
metric_delete_line()
{
	_exec_metric_api "delete-line" $1
}

# Fetch metric group.
metric_fetch()
{
	_exec_metric_api "fetch" $1 $2
}

# Fetch metric group line count.
metric_fetch_line_count()
{
	_exec_metric_api "fetch-line-count" $1
}

# Fetch metric group headers.
metric_fetch_headers()
{
	_exec_metric_api "fetch-headers" $1
}

# List groups.
metric_list()
{	
	metric_list_group
}

# List groups.
metric_list_group()
{
	_exec_metric_api "list-group"
}
