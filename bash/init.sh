#!/bin/bash

# ###############################################################
# SECTION: HELPER FUNCTIONS
# ###############################################################

# Activates a virtual environment.
activate_venv()
{
	if [ $1 = "server" ]; then
		export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_REPOS/prodiguer-client
		export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_REPOS/prodiguer-server
	elif [ $1 = "conso" ]; then
		# export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_REPOS/prodiguer-conso
		export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_REPOS/prodiguer-server
	fi
	source $PRODIGUER_DIR_VENV/$1/bin/activate
	log "Activated virtual environment: "$1
}

# Wraps standard echo by adding PRODIGUER prefix.
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
	    	echo -e $now" [INFO] :: IPSL PRODIGUER-SHELL > "$tabs$1
	    else
	    	echo -e $now" [INFO] :: IPSL PRODIGUER-SHELL > "$1
	    fi
	else
	    echo -e $now" [INFO] :: IPSL PRODIGUER-SHELL > "
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
	rm -rf $PRODIGUER_DIR_TMP/*
	mkdir -p $PRODIGUER_DIR_TMP
}

# Assigns the current working directory.
set_working_dir()
{
	if [ "$1" ]; then
		cd $1
	else
		cd $PRODIGUER_HOME
	fi
}

# ###############################################################
# SECTION: INITIALIZE PATHS
# ###############################################################

declare PRODIGUER_DIR_BASH=$PRODIGUER_HOME/bash
declare PRODIGUER_DIR_BACKUPS=$PRODIGUER_HOME/ops/backups
declare PRODIGUER_DIR_CERTS=$PRODIGUER_HOME/ops/certs
declare PRODIGUER_DIR_CONFIG=$PRODIGUER_HOME/ops/config
declare PRODIGUER_DIR_DAEMONS=$PRODIGUER_HOME/ops/daemons
declare PRODIGUER_DIR_DATA=$PRODIGUER_HOME/ops/data
declare PRODIGUER_DIR_JOBS=$PRODIGUER_HOME/repos/prodiguer-server/jobs
declare PRODIGUER_DIR_LOGS=$PRODIGUER_HOME/ops/logs
declare PRODIGUER_DIR_PYTHON=$PRODIGUER_HOME/ops/venv/python
declare PRODIGUER_DIR_REPOS=$PRODIGUER_HOME/repos
declare PRODIGUER_DIR_TEMPLATES=$PRODIGUER_HOME/templates
declare PRODIGUER_DIR_SERVER=$PRODIGUER_HOME/repos/prodiguer-server
declare PRODIGUER_DIR_SERVER_TESTS=$PRODIGUER_HOME/repos/prodiguer-server/tests
declare PRODIGUER_DIR_TMP=$PRODIGUER_HOME/ops/tmp
declare PRODIGUER_DIR_VENV=$PRODIGUER_HOME/ops/venv

# ###############################################################
# SECTION: INITIALIZE VARS
# ###############################################################

# Set of git repos.
declare -a PRODIGUER_REPOS=(
	'prodiguer-client'
	'prodiguer-cv'
	'prodiguer-docs'
	'prodiguer-fe'
	'prodiguer-server'
)

# Set of virtual environments.
declare -a PRODIGUER_VENVS=(
	'conso'
	'server'
)

# Set of ops sub-directories.
declare -a PRODIGUER_OPS_DIRS=(
	$PRODIGUER_DIR_BACKUPS
	$PRODIGUER_DIR_CONFIG
	$PRODIGUER_DIR_CERTS
	$PRODIGUER_DIR_CERTS/rabbitmq
	$PRODIGUER_DIR_DAEMONS
	$PRODIGUER_DIR_DAEMONS/db
	$PRODIGUER_DIR_DAEMONS/mq
	$PRODIGUER_DIR_DAEMONS/web
	$PRODIGUER_DIR_DATA
	$PRODIGUER_DIR_DATA/pgres
	$PRODIGUER_DIR_DATA/mongo
	$PRODIGUER_DIR_LOGS
	$PRODIGUER_DIR_LOGS/db
	$PRODIGUER_DIR_LOGS/mq
	$PRODIGUER_DIR_LOGS/web
	$PRODIGUER_DIR_PYTHON
	$PRODIGUER_DIR_TMP
	$PRODIGUER_DIR_VENV
)

# ###############################################################
# SECTION: Initialise file system
# ###############################################################

# Ensure ops paths exist.
for ops_dir in "${PRODIGUER_OPS_DIRS[@]}"
do
	mkdir -p $ops_dir
done

# Clear temp files.
reset_tmp
