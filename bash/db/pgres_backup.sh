source $HERMES_HOME/bash/init.sh

# Initialises the db backup dir.
_init_backup_dir()
{
	FINAL_DB_BACKUP_DIR=$HERMES_DIR_BACKUPS"/db/""`date +\%Y-\%m-\%d`/"

	log "Making backup directory @ $FINAL_DB_BACKUP_DIR"

	if ! mkdir -p $FINAL_DB_BACKUP_DIR; then
		log "Cannot create backup directory in $FINAL_DB_BACKUP_DIR. Probably a permissions issue.  Go and fix it!"
		exit 1;
	fi;
}

_do_backup()
{
	log "db = $1 :: back up begins "

	$HERMES_DB_PGRES_PGDUMP "$1" -U hermes_db_admin -c -f $FINAL_DB_BACKUP_DIR"$1".sql;
	log "db = $1 :: back up file @ $FINAL_DB_BACKUP_DIR$1.sql"

	log "db = $1 :: back up ends"
}

# Performs backup.
_do()
{
	log "Performing backups"

	FULL_BACKUP_QUERY="select datname from pg_database where not datistemplate order by datname;"
	for DATABASE in `psql -h localhost -U hermes_db_admin -At -c "$FULL_BACKUP_QUERY" postgres`
	do
		if [[ $DATABASE == $HERMES_DB_PGRES_NAME* ]];
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
