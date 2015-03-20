#!/bin/bash

# ###############################################################
# SECTION: INITIALIZE VARS
# ###############################################################

# Version of python used by stack.
declare PYTHON_VERSION=2.7.9

# Optional system user to run backups as.  If the user the script is running as doesn't match this the script terminates.  Leave blank to skip check.
declare DB_BACKUP_USER=

# This dir will be created if it doesn't exist.  This must be writable by the user the script is running as.  Will default to ~/prodiguer/db/backups
declare DB_BACKUP_DIR=$DIR_BACKUPS/db

# Which day to take the weekly backup from (1-7 = Monday-Sunday).  Defaults to Friday.
declare DB_DAY_OF_WEEK_TO_KEEP=5

# Number of days to keep daily backups.  Defaults to 7 (1 week).
declare DB_DAYS_TO_KEEP=7

# How many weeks to keep weekly backups.  Defaults to 5 (1 month)
declare DB_WEEKS_TO_KEEP=5

# Path to pg_dump executable.
declare DB_PGDUMP=/usr/bin/pg_dump

# Username of GitHub account used to push changes to GitHub.
declare GIT_USERNAME=prodiguer-git-user

# Email of GitHub account used to push changes to GitHub.
declare GIT_EMAIL=mark.morgan@ipsl.jussieu.fr
