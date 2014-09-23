#!/bin/bash

# ###############################################################
# SECTION: DB FUNCTIONS
# ###############################################################

# Performs pre db backup checks.
_db_verify_backup()
{
	# Make sure we're running as the required backup user
	if [ "$DB_BACKUP_USER" != "" -a "$(id -un)" != "$DB_BACKUP_USER" ]; then
		log "This script must be run as $DB_BACKUP_USER. Exiting."
		exit 1;
	fi;
}

# Initialises the db backup dir.
_db_init_backup_dir()
{
	FINAL_DB_BACKUP_DIR=$DB_BACKUP_DIR"`date +\%Y-\%m-\%d`/"

	log "Making backup directory @ $FINAL_DB_BACKUP_DIR"

	if ! mkdir -p $FINAL_DB_BACKUP_DIR; then
		log "Cannot create backup directory in $FINAL_DB_BACKUP_DIR. Probably a permissions issue.  Go and fix it!"
		exit 1;
	fi;
}

_db_backup()
{
	log "db = $1 :: back up begins"

	if ! pg_dump -Fp -h localhost -U prodiguer_db_admin "$1" | gzip > $FINAL_DB_BACKUP_DIR"$DATABASE".sql.gz.in_progress; then
		log "[!!ERROR!!] Failed to produce plain backup database $1"
	else
		mv $FINAL_DB_BACKUP_DIR"$1".sql.gz.in_progress $FINAL_DB_BACKUP_DIR"$1".sql.gz
	fi
	log "db = $1 :: back up file @ $FINAL_DB_BACKUP_DIR$1.sql.gz"

	log "db = $1 :: back up ends"
}

_dbs_backup()
{
	log "Performing backups"

	FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate order by datname;"
	for DATABASE in `psql -h localhost -U prodiguer_db_admin -At -c "$FULL_BACKUP_QUERY" postgres`
	do
		if [[ $DATABASE == prodiguer* ]];
		then
			_db_backup $DATABASE
		fi
	done

	log "All database backups complete!"
}

# Create db users.
_db_create_users()
{
	log "Creating DB users"

	createuser -U postgres -d -s prodiguer_db_admin
	createuser -U prodiguer_db_admin -D -S -R prodiguer_db_user
}

# Create db.
_db_create()
{
	log "Creating DB"

	createdb -U prodiguer_db_admin -e -O prodiguer_db_admin -T template0 prodiguer
	createdb -U prodiguer_db_admin -e -O prodiguer_db_admin -T template0 prodiguer_test
}

# Grant db permissions.
_db_grant_permissions()
{
	log "Granting DB permissions"

	psql -U prodiguer_db_admin -d prodiguer -a -f $DIR_BASH/run_db_grant_permissions.sql
	psql -U prodiguer_db_admin -d prodiguer_test -a -f $DIR_BASH/run_db_grant_permissions.sql
}

# Create db users.
_db_drop_users()
{
	log "Deleting DB users"

	dropuser -U prodiguer_db_admin prodiguer_db_user
	dropuser -U postgres prodiguer_db_admin
}

# Drop db.
_db_drop()
{
	log "Dropping DB"

	dropdb -U prodiguer_db_admin prodiguer
	dropdb -U prodiguer_db_admin prodiguer_test
}

# Seed db.
_db_setup()
{
	log "Seeding DB"

	activate_venv server
	python $DIR_JOBS/db/run_setup.py
}

# Backup db.
run_db_backup()
{
	log "DB : backing up ..."

	_db_verify_backup
	_db_init_backup_dir
	_dbs_backup

	log "DB : backed up"
}

# Install db.
run_db_install()
{
	log "DB : installing ..."

	_db_create_users
	_db_create
	_db_setup
	_db_grant_permissions

	log "DB : installed ..."
}

# Reset db.
run_db_reset()
{
	log "DB : resetting ..."

	run_db_uninstall
	run_db_install

	log "DB : reset"
}

# Restore db.
run_db_restore()
{
	log "DB : restoring ..."

	log "TODO"

	log "DB : restored"
}

# Uninstall db.
run_db_uninstall()
{
	log "DB : uninstalling ..."

	run_db_backup
	_db_drop
	_db_drop_users

	log "DB : uninstalled"
}
