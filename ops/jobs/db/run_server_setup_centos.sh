# Sets up common system dependencies.
setup_common()
{
	# Ensure machine is upto date.
	yum upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum groupinstall -y development
	yum install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql93-libs postgresql-devel postgresql93-devel python-devel postgresql93-plpython python-psycopg2
}

# Installs postgres db server.
setup_postgres()
{
	# Install yum PostgreSQL repository.
	log "Installing PostgreSQL repo"
	rpm -Uvh http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm

	# Install PostgreSQL with yum package manager.
	log "Installing PostgreSQL with yum package manager"
	yum install postgresql93-server postgresql93

	# Initialize PostgreSQL server.
	log "Initializing PostgreSQL server"
	/etc/init.d/postgresql-9.3 initdb

	# Setup PostgreSQL service to auto start on system boot.
	log "Setting up PostgreSQL server to auto-start on system boot"
	chkconfig postgresql-9.3 on

	# Copy pg_hba.conf template.
	rm /var/lib/pgsql/9.3/data/pg_hba.conf
	cp $DIR_TEMPLATES/config/pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf

	# Start PostgreSQL service using following command.
	log "Starting PostgreSQL server"
	service postgresql-9.3 start
}

# Installs mongodb db server.
setup_mongodb()
{
	# Configure the package management system (YUM).
	cp $DIR_TEMPLATES/other/yum-repo-mongodb.repo /etc/yum.repos.d/mongodb.repo

	# Install latest stable version of mongodb.
	yum install -y mongodb-org
}

# Main entry point.
main()
{
	# Download prodiguer shell.
	yum install git
	cd /opt
	git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

	# Set vars.
	declare DIR_TEMPLATES=./prodiguer/templates

	# Install common libraries.
	setup_common

	# Install postgres db server.
	setup_postgres

	# Install mogondb db server.
	setup_mongodb

	# Install stack.
	./prodiguer/exec.sh stack-bootstrap
	./prodiguer/exec.sh stack-install
	./prodiguer/exec.sh db-install
}

# Invoke entry point.
main()
