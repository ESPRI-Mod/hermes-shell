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
		cv
		db
		mq
		os
		stack
		utest
		web
	)
	log "------------------------------------------------------------------"
	for helper in "${helpers[@]}"
	do
		help_$helper
		log "------------------------------------------------------------------"
	done
}


