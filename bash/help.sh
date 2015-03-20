#!/bin/bash

# ###############################################################
# SECTION: HELP
# ###############################################################

# Displays help text to user.
log_help_commands()
{
	local typeof=$1
	shift
	local cmds=$@
	log $typeof" commands:"
	for cmd in $cmds
	do
		"help_"$typeof"_"$cmd
		log
	done
}

# Displays help text to user.
run_help()
{
	helpers=(
		help_cv
		help_db
		help_metric
		help_mq
		help_stack
		help_utests
		help_web
	)

	log "------------------------------------------------------------------"
	for helper in "${helpers[@]}"
	do
		$helper
		log "------------------------------------------------------------------"
	done
}


