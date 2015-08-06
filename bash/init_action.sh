#!/bin/bash

# ###############################################################
# SECTION: INITIALIZE PRODIGUER_ACTION
# ###############################################################

# Set action.
declare PRODIGUER_ACTION=`echo $1 | tr '[:upper:]' '[:lower:]' | tr '-' '_'`
if [[ $PRODIGUER_ACTION == help_* ]]; then
	:
elif [[ $PRODIGUER_ACTION != run_* ]]; then
	declare PRODIGUER_ACTION="run_"$PRODIGUER_ACTION
fi

# Set action arguments.
declare PRODIGUER_ACTION_ARG1=$2
declare PRODIGUER_ACTION_ARG2=$3
declare PRODIGUER_ACTION_ARG3=$4
declare PRODIGUER_ACTION_ARG4=$5
declare PRODIGUER_ACTION_ARG5=$6

