# ###############################################################
# SECTION: API METRIC
# ###############################################################

_exec_metric_api()
{
	declare action=`echo $1 | tr '[:upper:]' '[:lower:]' | tr '-' '_'`

	activate_venv server
	python $DIR_JOBS/api/metric/run_$action.py $2 $3 $4
}

# Add metrics.
run_metric_add()
{
	_exec_metric_api "add" $1
}

# Delete metric.
run_metric_delete()
{
	_exec_metric_api "delete" $1 $2
}

# Delete metric lines.
run_metric_delete_lines()
{
	_exec_metric_api "delete-lines" $1 $2
}

# Fetch metric group.
run_metric_fetch()
{
	_exec_metric_api "fetch" $1 $2 $3
}

# Fetch metric group columns.
run_metric_fetch_columns()
{
	_exec_metric_api "fetch-columns" $1 $2
}

# Fetch metric count.
run_metric_fetch_count()
{
	_exec_metric_api "fetch-count" $1 $2
}

# List groups.
run_metric_fetch_list()
{
	_exec_metric_api "fetch-list"
}

# Fetch metric group line count.
run_metric_fetch_setup()
{
	_exec_metric_api "fetch-setup" $1 $2
}
