#!/bin/bash

# ###############################################################
# SECTION: INITIALIZE VARS FROM CONFIG
# ###############################################################

# If produguer.sh config file exists then import variable definitions.
test -f $DIR_CONFIG/prodiguer.sh && source $DIR_CONFIG/prodiguer.sh

# Set of git repos.
declare -a REPOS=(
	'prodiguer-client'
	'prodiguer-cv'
	'prodiguer-docs'
	'prodiguer-fe'
	'prodiguer-server'
)

# Set of obsolete git repos.
declare -a REPOS_OBSOLETE=(
	'prodiguer-metrics-formatter'
)

# Set of ops sub-directories.
declare -a OPS_DIRS=(
	$DIR_BACKUPS
	$DIR_CONFIG
	$DIR_CERTS
	$DIR_CERTS/rabbitmq
	$DIR_DAEMONS
	$DIR_DAEMONS/mq
	$DIR_DAEMONS/web
	$DIR_DATA
	$DIR_DATA/pgres
	$DIR_DATA/mongo
	$DIR_LOGS
	$DIR_LOGS/db
	$DIR_LOGS/mq
	$DIR_LOGS/web
	$DIR_PYTHON
	$DIR_TMP
	$DIR_VENV
)

# Set of virtual environments.
declare -a VENVS=(
	'server'
)
