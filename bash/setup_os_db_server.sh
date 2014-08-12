#!/bin/bash

# ###############################################################
# SECTION: DB SERVER SETUP
# ###############################################################

# Sets up centos  db server.
run_setup_centos_db_server()
{
	# Install common libraries.
	run_setup_centos_common

	# Install db server.
	run_centos_db_server_install_postgres
}

# Installs postgres db server.
run_centos_db_server_install_postgres()
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
	cp $DIR_TEMPLATES/template-pg_hba.conf /var/lib/pgsql/9.3/data/pg_hba.conf

	# Start PostgreSQL service using following command.
	log "Starting PostgreSQL server"
	service postgresql-9.3 start
}