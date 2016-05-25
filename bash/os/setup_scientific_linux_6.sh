# Installs common libraries.
hermes_setup_common()
{
	# Ensure machine is upto date.
	yum -q -y update
	yum -q -y upgrade

	# Enable EPEL v6.
	yum -q -y install epel-release

	# Install various tools.
	yum -q -y install git
	yum -q -y install xz-libs
	yum -q -y install zlib-devel
	yum -q -y install bzip2-devel
	yum -q -y install openssl-devel
	yum -q -y install ncurses-devel
	yum -q -y install sqlite-devel
	yum -q -y install readline-devel
	yum -q -y install tk-devel
	yum -q -y install gdbm-devel
	yum -q -y install db4-devel
	yum -q -y install libpcap-devel
	yum -q -y install postgresql-client
	yum -q -y install postgresql-devel
	yum -q -y install python-devel
	yum -q -y install postgresql-plpython
	yum -q -y install python-psycopg2
	yum -q -y install gcc-c++
	yum -q -y install freetype-devel
	yum -q -y install libpng-devel
	yum -q -y install python-matplotlib
}

# Installs NGINX web server.
hermes_setup_nginx()
{
	# Install nginx.
	yum -q -y install nginx

	# Update nginx configuration.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/web-nginx.conf -O /etc/nginx/nginx.conf
}

# Installs mongodb db server.
hermes_setup_mongodb()
{
	# Install MongoDB.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/db-mongodb-org-scientific-linux-6.repo -O /etc/yum.repos.d/mongodb-org.repo
	yum -q -y install mongodb-org

	# Start MongoDB service.
	service mongod start
}

# Installs postgres db server.
# see http://www.unixmen.com/postgresql-9-4-released-install-centos-7.
hermes_setup_postgresql()
{
	# Install PostgreSQL repository.
	rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-sl94-9.4-1.noarch.rpm
	yum -q -y update

	# Install PostgreSQL.
	yum -q -y install postgresql94-server postgresql94-contrib

	# Initialize PostgreSQL database.
	service postgresql-9.4 initdb

	# Install default configuration.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/db_pg_hba.conf -O /var/lib/pgsql/9.4/data/pg_hba.conf

	# Setup PostgreSQL service to auto start on system boot.
	chkconfig postgresql-9.4 on

	# Start PostgreSQL service.
	service postgresql-9.4 start

	# Install client tools.
	yum -q -y install pgadmin3_94
}

# Installs RabbitMQ server.
hermes_setup_rabbitmq()
{
	# Install dependencies.
	yum -q -y install erlang

	# Install RabbitMQ repository.
	rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	rpm -Uvh https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_4/rabbitmq-server-3.5.4-1.noarch.rpm
	yum -q -y update

	# Install RabbitMQ.
	yum -q -y install rabbitmq-server

	# Initialise configuration.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/mq-rabbit.config -O /etc/rabbitmq/rabbitmq.config

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Setup RabbitMQ service to auto start on system boot.
	chkconfig rabbitmq-server on

	# Start RabbitMQ service.
	service rabbitmq-server start

	# Set RabbitMQ admin cli.
	wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_4/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
	chmod a+x /usr/local/bin/rabbitmqadmin

	# Import RabbitMQ broker definitions.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/mq-rabbit-broker-definitions.json
	rabbitmqctl set_user_tags guest administrator
	rabbitmqadmin -q import ./mq-rabbit-broker-definitions.json
	rm -f ./mq-rabbit-broker-definitions.json

	# Remove default user.
	rabbitmqctl delete_user guest
}
