#!/bin/bash

declare -a initializers=(
	'init_action'
	'init_helpers'
	'init_paths'
	'init_vars'
	'run_api'
	'run_api_metric'
	'run_db_mongo'
	'run_db_pgres'
	'run_demos'
	'run_help'
	'run_monitoring'
	'run_mq'
	'run_stack'
	'run_tests'
)
for initializer in "${initializers[@]}"
do
	source $DIR/bash/$initializer.sh
done
