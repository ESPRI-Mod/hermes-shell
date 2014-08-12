#!/bin/bash

declare -a initializers=(
	'init_action'
	'init_helpers'
	'init_paths'
	'init_vars'
	'run_api'
	'run_centos'
	'run_db'
	'run_demo'
	'run_help'
	'run_mq'
	'run_stack'
	'run_tests'
	'setup_os'
	'setup_os_db_server'
	'setup_os_mq_server'
	'setup_os_web_server'
)
for initializer in "${initializers[@]}"
do
	source $DIR/bash/$initializer.sh
done
