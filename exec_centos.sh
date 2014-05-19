#!/bin/bash

# ###############################################################
# SECTION: DB COMMANDS
# ###############################################################

# Installs db server.
run_centos_db_server_pginstall()
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

# Sets up libraries used on all servers.
_run_centos_common_libraries_install()
{
	# Ensure machine is upto date.
	yum upgrade

	# Install various tools.
	yum groupinstall -y development
	yum install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql93-libs postgresql-devel postgresql93-devel python-devel postgresql93-plpython python-psycopg2
}

# Sets up the db server.
run_centos_db_server_setup() 
{
	# Install common libraries.
	_run_centos_common_libraries_install
}

# Sets up the web server.
run_centos_web_server_setup() 
{
	# Install common libraries.
	_run_centos_common_libraries_install

	# Install nginx.
	rpm -i $DIR_OS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum install nginx	

	# Create fe logs.
	mkdir $DIR_FE/logs

	# Update nginx configuration.
	cp $DIR_TEMPLATES/template-nginx.conf /etc/nginx/nginx.conf
}
