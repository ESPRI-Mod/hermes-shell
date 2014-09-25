#!/bin/bash

# ###############################################################
# SECTION: INITIALIZE ACTION
# ###############################################################

# Set action.
declare ACTION=`echo $1 | tr '[:upper:]' '[:lower:]' | tr '-' '_'`
if [[ $ACTION != run_* ]]; then
	declare ACTION="run_"$ACTION
fi

# Set action argument.
declare ACTION_ARG=$2

# Set action sub-arguments.
declare ACTION_SUBARG1=$3
declare ACTION_SUBARG2=$4

