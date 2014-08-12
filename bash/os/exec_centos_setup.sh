#!/bin/bash

# Declare helper vars.
declare SERVER_TYPE=$1
declare REPO=https://github.com/Prodiguer/prodiguer-shell.git

# Set working directory.
cd /opt

# Ensure that git is available.
yum install git

# Clone prodiguer shell.
rm -rf prodiguer
git clone $REPO prodiguer

# Run server setup.
if [ $SERVER_TYPE = "db" ]; then
	./prodiguer/exec.sh setup-centos-db-server
elif [ $SERVER_TYPE = "mq" ]; then
	./prodiguer/exec.sh setup-centos-mq-server
elif [ $SERVER_TYPE = "web" ]; then
	./prodiguer/exec.sh setup-centos-web-server
fi

# Install stack.
./prodiguer/exec.sh stack-bootstrap
./prodiguer/exec.sh stack-install

# Install db.
./prodiguer/exec.sh run-db-install

# Run post setup tasks.
if [ $SERVER_TYPE = "db" ]; then
	./prodiguer/exec.sh run-tests db
elif [ $SERVER_TYPE = "web" ]; then
	nginx -s reload
fi
