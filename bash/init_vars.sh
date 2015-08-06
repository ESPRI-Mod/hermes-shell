#!/bin/bash

# ###############################################################
# SECTION: INITIALIZE VARS FROM CONFIG
# ###############################################################

# If produguer.sh config file exists then import variable definitions.
test -f $PRODIGUER_DIR_CONFIG/prodiguer.sh && source $PRODIGUER_DIR_CONFIG/prodiguer.sh

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
