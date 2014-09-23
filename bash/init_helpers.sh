#!/bin/bash

# ###############################################################
# SECTION: HELPER FUNCTIONS
# ###############################################################

# Wraps standard echo by adding PRODIGUER prefix.
log()
{
	declare tabs=''
	if [ "$1" ]; then
		if [ "$2" ]; then
			for ((i=0; i<$2; i++))
			do
				declare tabs+='\t'
			done
	    	echo -e 'IPSL PRODIGUER INFO SH > '$tabs$1
	    else
	    	echo -e "IPSL PRODIGUER INFO SH > "$1
	    fi
	else
	    echo -e "IPSL PRODIGUER INFO SH > "
	fi
}

# Outputs a line to split up logging.
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