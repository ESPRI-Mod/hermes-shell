#!/bin/bash

# ###############################################################
# SECTION: MAIN
# ###############################################################

declare SERVER_TYPE=$1
echo $SERVER_TYPE
log "Setting up "$SERVER_TYPE" server ..."

exit 0


# Login as root.
su

# Goto working directory.
cd /opt

# Ensure that git is available.
yum install git

# Clone prodiguer shell.
git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

# Set alias.
alias prodiguer=./prodiguer/exec.sh

# Run server setup.
if [ $SERVER_TYPE = "db" ]; then
	prodiguer setup-centos-db-server
elif [ $SERVER_TYPE = "mq" ]; then
	prodiguer setup-centos-mq-server
elif [ $SERVER_TYPE = "web" ]; then
	prodiguer setup-centos-web-server
fi

# Install stack.
prodiguer stack-bootstrap
prodiguer stack-install

# Install db.
prodiguer run-db-install

# Run post setup tasks.
if [ $SERVER_TYPE = "db" ]; then
	prodiguer run-tests db
elif [ $SERVER_TYPE = "web" ]; then
	nginx -s reload
fi

# ###############################################################
# SECTION: HELPERS
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
	    echo -e ""
	fi
}

# Outputs a line to split up logging.
log_banner()
{
	echo "-------------------------------------------------------------------------------"
}