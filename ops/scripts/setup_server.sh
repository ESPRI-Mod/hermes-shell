#!/bin/bash

# ###############################################################
# SECTION: COMMON SETUP
# ###############################################################

# Sets up libraries used on all centos servers.
setup_common_libs()
{
	# Ensure machine is upto date.
	yum upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	yum install foo

	# Install various tools.
	yum groupinstall -y development
	yum install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql93-libs postgresql-devel postgresql93-devel python-devel postgresql93-plpython python-psycopg2
}

# ###############################################################
# SECTION: DB SERVER SETUP
# ###############################################################

# Sets up centos  db server.
setup_db_server()
{
	# Install common libraries.
	setup_common_libs

	# Install db server.
	setup_db_server_install_postgres
}

# Installs postgres db server.
setup_db_server_install_postgres()
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

# ###############################################################
# SECTION: MQ SERVER SETUP
# ###############################################################

# Sets up the mq server.
# See - http://sensuapp.org/docs/0.11/installing_rabbitmq_centos
setup_centos_mq_server()
{
	# Install common libraries.
	setup_common_libs

	# Install dependencies.
	yum install erlang

	# Install RabbitMQ.
	rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.5/rabbitmq-server-3.3.5-1.noarch.rpm

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Set RabbitMQ to start on boot and start it up immediately.
	/sbin/chkconfig rabbitmq-server on
	/etc/init.d/rabbitmq-server start

	# Set RabbitMQ admin cli.
	wget http://hg.rabbitmq.com/rabbitmq-management/raw-file/rabbitmq_v3_3_5/bin/rabbitmqadmin -O /opt/prodiguer/tmp/rabbitmqadmin
	cp /opt/prodiguer/tmp/rabbitmqadmin /usr/local/bin
	rm -rf /opt/prodiguer/tmp/rabbitmqadmin

	# Import RabbitMQ config.
	rabbitmqadmin -q import $DIR_CONFIG/mq-server/rabbitmq-setup.json

	# Delete obsolete MQ server resources.
	rabbitmqctl delete_user guest
}

# ###############################################################
# SECTION: MQ SERVER SETUP
# ###############################################################

# Sets up the web server.
setup_web_server()
{
	# Install common libraries.
	setup_common_libs

	# Install nginx.
	setup_web_server_install_nginx
}

# Sets up NGINX upon web server.
setup_web_server_install_nginx()
{
	# Install nginx.
	rpm -i $DIR_TEMPLATES/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum install nginx

	# Update nginx configuration.
	cp $DIR_TEMPLATES/template-nginx.conf /etc/nginx/nginx.conf
}


# ###############################################################
# SECTION: MAIN
# ###############################################################

# Ensure that git is available.
yum install git

# Set working directory.
cd /opt

# Set paths.
declare DIR=./prodiguer
declare DIR_CONFIG=$DIR/ops/config

# Declare helper vars.
declare SERVER_TYPE=$1
declare REPO=https://github.com/Prodiguer/prodiguer-shell.git

# Download prodiguer shell.
rm -rf prodiguer
git clone $REPO prodiguer

# Run server setup.
if [ $SERVER_TYPE = "db" ]; then
	setup_db_server
elif [ $SERVER_TYPE = "mq" ]; then
	setup_mq_server
elif [ $SERVER_TYPE = "web" ]; then
	setup_web_server
fi

# Install stack.
./prodiguer/exec.sh stack-bootstrap
./prodiguer/exec.sh stack-install

# Run post stack install tasks.
if [ $SERVER_TYPE = "db" ]; then
	./prodiguer/exec.sh db-install
elif [ $SERVER_TYPE = "web" ]; then
	nginx -s reload
fi
