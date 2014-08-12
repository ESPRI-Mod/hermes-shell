#!/bin/bash

# Ensure that git is available.
yum install git

# Set working directory.
cd /opt

# Declare helper vars.
declare SERVER_TYPE=$1
declare REPO=https://github.com/Prodiguer/prodiguer-shell.git

# Download prodiguer shell.
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

# Run post stack install tasks.
if [ $SERVER_TYPE = "db" ]; then
	./prodiguer/exec.sh run-db-install
elif [ $SERVER_TYPE = "web" ]; then
	nginx -s reload
fi
