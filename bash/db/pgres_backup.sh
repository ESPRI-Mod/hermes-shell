source $PRODIGUER_HOME/bash/init.sh

# Performs pre db backup checks.
_verify()
{
	# Make sure we're running as the required backup user
	if [ "$DB_BACKUP_USER" != "" -a "$(id -un)" != "$DB_BACKUP_USER" ]; then
		log "This script must be run as $DB_BACKUP_USER. Exiting."
		exit 1;
	fi;
}

# Initialises the db backup dir.
_init_backup_dir()
{
	FINAL_DB_BACKUP_DIR=$DB_BACKUP_DIR"/""`date +\%Y-\%m-\%d`/"

	log "Making backup directory @ $FINAL_DB_BACKUP_DIR"

	if ! mkdir -p $FINAL_DB_BACKUP_DIR; then
		log "Cannot create backup directory in $FINAL_DB_BACKUP_DIR. Probably a permissions issue.  Go and fix it!"
		exit 1;
	fi;
}

# Performs backup.
_do_backup()
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

log "DB : backing up postgres db ..."

_verify
_init_backup_dir
_do_backup

log "DB : backed up postgres db"
