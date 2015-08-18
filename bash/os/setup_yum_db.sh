# Installs postgres db server.
_setup_postgres()
{
	# Install yum -q PostgreSQL repository.
	log "Installing PostgreSQL repo"
	rpm ­-ivh $PRODIGUER_DIR_TEMPLATES/other/pgdg-centos94-9.4-1.noarch.rpm

	# Install PostgreSQL with yum -q package manager.
	log "Installing PostgreSQL with yum -q package manager"
	yum -q -y install postgresql-server postgresql

	# Initialize PostgreSQL server.
	log "Initializing PostgreSQL server"
	service postgresql initdb

	# Setup PostgreSQL service to auto start on system boot.
	log "Setting up PostgreSQL server to auto-start on system boot"
	chkconfig postgresql on

	# Copy pg_hba.conf template.
	# rm /var/lib/pgsql/9.3/data/pg_hba.conf
	# cp $PRODIGUER_DIR_TEMPLATES/config/db-pgres-hba.conf /var/lib/pgsql/9.4/data/pg_hba.conf

	# Start PostgreSQL service using following command.
	log "Starting PostgreSQL server"
	service postgresql start
}

# Installs mongodb db server.
_setup_mongodb()
{
	# Configure the package management system (YUM).
	cp $PRODIGUER_DIR_TEMPLATES/other/yum-repo-mongodb.repo /etc/yum.repos.d/mongodb.repo

	# Install latest stable version of mongodb.
	yum -q -y install mongodb-org
}

# Main entry point.
main()
{
	# Install postgres db server.
	_setup_postgres

	# Install mogondb db server.
	_setup_mongodb
}

# Invoke entry point.
main
