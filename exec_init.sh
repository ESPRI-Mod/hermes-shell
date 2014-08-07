#!/bin/bash

# ###############################################################
# SECTION: INIT
# ###############################################################

# Set path: root.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set path: db.
DIR_DB=$DIR/db

# Set path: fe.
DIR_FE=$DIR/fe

# Set path: os.
DIR_OS=$DIR/os

# Set path: git repos.
DIR_REPOS=$DIR/repos

# Set path: templates.
DIR_TEMPLATES=$DIR/templates

# Set path: tmp.
DIR_TMP=$DIR/tmp

# Set path: virtual environments.
DIR_VENV=$DIR/venv

# Set path: python.
DIR_PYTHON=$DIR_VENV/python

# Set path: server.
DIR_SERVER=$DIR_REPOS/prodiguer-server

# Set path: server demos.
DIR_SERVER_DEMOS=$DIR_REPOS/prodiguer-server/demos


# Set action.
ACTION=`echo $1 | tr '[:upper:]' '[:lower:]' | tr '-' '_'`
if [[ $ACTION != run-* ]]; then
	ACTION="run_"$ACTION
fi

# Set action argument.
ACTION_ARG=$2

# Set action sub-arguments.
ACTION_SUBARG1=$3
ACTION_SUBARG2=$4

##############################
## INIT MISC VARS			##
##############################

# Version of python used by stack.
PYTHON_VERSION=2.7.6


##############################
## INIT DB VARS				##
##############################
 
# Optional system user to run backups as.  If the user the script is running as doesn't match this the script terminates.  Leave blank to skip check.
DB_BACKUP_USER=
 
# This dir will be created if it doesn't exist.  This must be writable by the user the script is running as.  Will default to ~/prodiguer/db/backups
DB_BACKUP_DIR=$DIR_DB/backups
  
# Which day to take the weekly backup from (1-7 = Monday-Sunday).  Defaults to Friday.
DB_DAY_OF_WEEK_TO_KEEP=5
 
# Number of days to keep daily backups.  Defaults to 7 (1 week).
DB_DAYS_TO_KEEP=7
 
# How many weeks to keep weekly backups.  Defaults to 5 (1 month)
DB_WEEKS_TO_KEEP=5


# ###############################################################
# SECTION: HELPER FUNCTIONS
# ###############################################################

# Wraps standard echo by adding PRODIGUER prefix.
log()
{
	tabs=''
	if [ "$1" ]; then
		if [ "$2" ]; then
			for ((i=0; i<$2; i++))
			do
				tabs+='\t'
			done
	    	echo -e 'IPSL PRODIGUER INFO SH > '$tabs$1	
	    else
	    	echo -e "IPSL PRODIGUER INFO SH > "$1	
	    fi
	else
	    echo -e ""	
	fi
}

log_banner()
{
	echo "-------------------------------------------------------------------------------"
}

# Assigns the current working directory.
set_working_dir()
{
	if [ "$1" ]; then
		cd $1
	else
		cd $DIR
	fi
}

# Activates a virtual environment.
activate_venv()
{	
	export PYTHONPATH=$PYTHONPATH:$DIR_REPOS/prodiguer-$1/src
	source $DIR_VENV/$1/bin/activate
}


# ###############################################################
# SECTION: MAIN
# ###############################################################

# Initialise working directory.
set_working_dir

