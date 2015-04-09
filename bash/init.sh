#!/bin/bash

declare -a initializers=(
	'init_action'
	'init_helpers'
	'init_paths'
	'init_vars'
)
for initializer in "${initializers[@]}"
do
	source $DIR/bash/$initializer.sh
done

declare -a commands=(
	'run_cv'
	'run_db_mongo'
	'run_db_pgres'
	'run_mq'
	'run_os'
	'run_stack'
	'run_utest'
	'run_web'
)
for command in "${commands[@]}"
do
	source $DIR/bash/$command.sh
done

declare -a helpers=(
	'help'
	'help_cv'
	'help_db'
	'help_mq'
	'help_os'
	'help_stack'
	'help_utest'
	'help_web'
)
for helper in "${helpers[@]}"
do
	source $DIR/bash/$helper.sh
done