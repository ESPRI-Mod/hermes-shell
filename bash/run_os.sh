#!/bin/bash

# ###############################################################
# SECTION: OS FUNCTIONS
# ###############################################################

# Parses operating system type name.
_parse_os_type()
{
	declare -a types=(
		'centos'
		'debian'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Parses machine type name.
_parse_machine_type()
{
	declare -a types=(
		'db'
		'dev'
		'mq'
		'web'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Sets up operating system so that prodiguer stack can execute.
run_os_setup()
{
	# Escape if operating system type is unsupported.
	declare os_type=$(_parse_os_type $1)
	if [ $os_type = 'UNKNOWN' ]; then
		log "Operating system ($1) is unsupported"
		exit
	fi

	# Escape if machine type is unsupported.
	declare machine_type=$(_parse_machine_type $2)
	if [ $machine_type = 'UNKNOWN' ]; then
		log "Machine type ($2) is unsupported"
		exit
	fi

	# Install common libraries setup.
	log "installing $os_type common libraries ..."
	source $PRODIGUER_DIR_BASH/run_os_setup_"$os_type".sh

	# Install machine specific libraries setup.
	log "installing $os_type $machine_type libraries ..."
	source $PRODIGUER_DIR_BASH/run_os_setup_"$os_type"_"$machine_type".sh
}