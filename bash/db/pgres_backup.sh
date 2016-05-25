source $HERMES_HOME/bash/init.sh

# Initialises the db backup dir.
_init_backup_dir()
{
	FINAL_DB_BACKUP_DIR=$PRODIGUER_DIR_BACKUPS"/db/""`date +\%Y-\%m-\%d`/"

	log "Making backup directory @ $FINAL_DB_BACKUP_DIR"

	if ! mkdir -p $FINAL_DB_BACKUP_DIR; then
		log "Cannot create backup directory in $FINAL_DB_BACKUP_DIR. Probably a permissions issue.  Go and fix it!"
		exit 1;
	fi;
}

_do_backup()
{
	log "db = $1 :: back up begins "

	if ! $HERMES_DB_PGRES_PGDUMP -Fp -h localhost -U prodiguer_db_admin "$1" | gzip > $FINAL_DB_BACKUP_DIR"$DATABASE".sql.gz.in_progress; then
		log "[!!ERROR!!] Failed to produce plain backup database $1"
	else
		mv $FINAL_DB_BACKUP_DIR"$1".sql.gz.in_progress $FINAL_DB_BACKUP_DIR"$1".sql.gz
	fi
	log "db = $1 :: back up file @ $FINAL_DB_BACKUP_DIR$1.sql.gz"

	log "db = $1 :: back up ends"
}

# Performs backup.
_do()
{
	log "Performing backups"

	FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate order by datname;"
	for DATABASE in `psql -h localhost -U prodiguer_db_admin -At -c "$FULL_BACKUP_QUERY" postgres`
	do
		if [[ $DATABASE == prodiguer* ]];
		then
			_do_backup $DATABASE
		fi
	done

	log "All database backups complete!"
}


log "DB : backing up postgres db ..."

_init_backup_dir
_do

log "DB : backed up postgres db"
