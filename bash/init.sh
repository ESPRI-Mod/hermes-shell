#!/bin/bash

# ###############################################################
# SECTION: HELPER FUNCTIONS
# ###############################################################

# Activates a virtual environment.
activate_venv()
{
	if [ $1 = "server" ]; then
		export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_REPOS/hermes-client
		export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_REPOS/hermes-server
		export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_REPOS/hermes-superviseur
	elif [ $1 = "conso" ]; then
		export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_REPOS/hermes-server
	fi
	source $HERMES_DIR_VENV/$1/bin/activate
	log "Activated virtual environment: "$1
}

# Wraps standard echo by adding HERMES prefix.
log()
{
	declare now=`date +%Y-%m-%dT%H:%M:%S`
	declare tabs=''
	if [ "$1" ]; then
		if [ "$2" ]; then
			for ((i=0; i<$2; i++))
			do
				declare tabs+='\t'
			done
	    	echo -e $now" [INFO] :: IPSL HERMES-SHELL > "$tabs$1
	    else
	    	echo -e $now" [INFO] :: IPSL HERMES-SHELL > "$1
	    fi
	else
	    echo -e $now" [INFO] :: IPSL HERMES-SHELL > "
	fi
}

# Outputs a line to split up logging.
log_banner()
{
	echo "-------------------------------------------------------------------------------"
}

# Removes all files of passed type in current working directory.
remove_files()
{
	find . -name $1 -exec rm -rf {} \;
}

# Resets temporary folder.
reset_tmp()
{
	rm -rf $HERMES_DIR_TMP/*
	mkdir -p $HERMES_DIR_TMP
}

# Assigns the current working directory.
set_working_dir()
{
	if [ "$1" ]; then
		cd $1
	else
		cd $HERMES_HOME
	fi
}

# ###############################################################
# SECTION: INITIALIZE PATHS
# ###############################################################

declare HERMES_DIR_BASH=$HERMES_HOME/bash
declare HERMES_DIR_BACKUPS=$HERMES_HOME/ops/backups
declare HERMES_DIR_CERTS=$HERMES_HOME/ops/certs
declare HERMES_DIR_CONFIG=$HERMES_HOME/ops/config
declare HERMES_DIR_DAEMONS=$HERMES_HOME/ops/daemons
declare HERMES_DIR_DATA=$HERMES_HOME/ops/data
declare HERMES_DIR_JOBS=$HERMES_HOME/repos/hermes-server/hermes_jobs
declare HERMES_DIR_LOGS=$HERMES_HOME/ops/logs
declare HERMES_DIR_PYTHON=$HERMES_HOME/ops/venv/python
declare HERMES_DIR_REPOS=$HERMES_HOME/repos
declare HERMES_DIR_TEMPLATES=$HERMES_HOME/templates
declare HERMES_DIR_SERVER=$HERMES_HOME/repos/hermes-server
declare HERMES_DIR_SERVER_TESTS=$HERMES_HOME/repos/hermes-server/tests
declare HERMES_DIR_TMP=$HERMES_HOME/ops/tmp
declare HERMES_DIR_VENV=$HERMES_HOME/ops/venv

# ###############################################################
# SECTION: INITIALIZE VARS
# ###############################################################

# GitHub urls.
declare HERMES_GITHUB=https://github.com/Prodiguer
declare HERMES_GITHUB_RAW=https://raw.githubusercontent.com/Prodiguer
declare HERMES_GITHUB_RAW_SHELL=$HERMES_GITHUB_RAW_SHELL

# Set of git repos.
declare -a HERMES_REPOS=(
	'hermes-client'
	'hermes-cv'
	'hermes-fe'
	'hermes-server'
	'hermes-superviseur'
)

# Set of virtual environments.
declare -a HERMES_VENVS=(
	'server'
)

# Set of ops sub-directories.
declare -a HERMES_OPS_DIRS=(
	$HERMES_DIR_BACKUPS
	$HERMES_DIR_CONFIG
	$HERMES_DIR_CERTS
	$HERMES_DIR_CERTS/rabbitmq
	$HERMES_DIR_DAEMONS
	$HERMES_DIR_DAEMONS/db
	$HERMES_DIR_DAEMONS/mq
	$HERMES_DIR_DAEMONS/web
	$HERMES_DIR_DATA
	$HERMES_DIR_DATA/pgres
	$HERMES_DIR_DATA/mongo
	$HERMES_DIR_LOGS
	$HERMES_DIR_LOGS/db
	$HERMES_DIR_LOGS/mq
	$HERMES_DIR_LOGS/web
	$HERMES_DIR_PYTHON
	$HERMES_DIR_TMP
	$HERMES_DIR_VENV
)

# ###############################################################
# SECTION: Initialise file system
# ###############################################################

# Ensure ops paths exist.
for ops_dir in "${HERMES_OPS_DIRS[@]}"
do
	mkdir -p $ops_dir
done

# Clear temp files.
reset_tmp
