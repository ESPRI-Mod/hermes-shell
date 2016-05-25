# Installs common libraries.
prodiguer_setup_common()
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
prodiguer_setup_nginx()
{
	# Install nginx.
	yum -q -y install nginx

	# Update nginx configuration.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/web-nginx.conf -O /etc/nginx/nginx.conf
}

# Installs mongodb db server.
prodiguer_setup_mongodb()
{
	# Install MongoDB.
	wget https://repo.mongodb.org/yum/redhat/mongodb-org.repo -O /etc/yum.repos.d/mongodb-org.repo
	yum -q -y install mongodb-org

	# Start MongoDB service.
	systemctl start mongod
}

# Installs postgres db server (v9.2).
prodiguer_setup_postgresql()
{
	# Install PostgreSQL repository.
	rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-sl94-9.4-1.noarch.rpm
	yum -q -y update

	# Install PostgreSQL.
	yum -q -y install postgresql94-server postgresql94-contrib

	# Initialize PostgreSQL database.
	postgresql-setup initdb

	# Install default configuration.
	wget $HERMES_GITHUB_RAW_SHELL/master/templates/db_pg_hba.conf -O /var/lib/pgsql/data/pg_hba.conf

	# Setup PostgreSQL service to auto start on system boot.
	systemctl enable postgresql

	# Start PostgreSQL service.
	systemctl start postgresql

	# Install client tools.
	yum -q -y install pgadmin3
}

# Installs RabbitMQ server.
prodiguer_setup_rabbitmq()
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
	systemctl enable rabbitmq-server

	# Start RabbitMQ service.
	systemctl start rabbitmq-server

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
