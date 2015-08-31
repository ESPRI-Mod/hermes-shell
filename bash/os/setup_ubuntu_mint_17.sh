# Installs common libraries.
prodiguer_setup_common()
{
	# Ensure machine is upto date.
	apt-get -qq -y update
	apt-get -qq -y upgrade

	# Install various libs.
	apt-get -qq -y install git
	apt-get -qq -y install libz-dev
	apt-get -qq -y install libffi-dev
	apt-get -qq -y install zlib1g-dev
	apt-get -qq -y install bzip2
	apt-get -qq -y install openssl
	apt-get -qq -y install libssl-dev
	apt-get -qq -y install ncurses-dev
	apt-get -qq -y install sqlite3
	apt-get -qq -y install libsqlite-dev
	apt-get -qq -y install libreadline-dev
	apt-get -qq -y install tk
	apt-get -qq -y install libgdbm-dev
	apt-get -qq -y install libdb6.0-dev
	apt-get -qq -y install libpcap-dev
	apt-get -qq -y install postgresql-client
	apt-get -qq -y install python-dev
	apt-get -qq -y install python-pip
	apt-get -qq -y install postgresql-plpython
	apt-get -qq -y install python-psycopg2
	apt-get -qq -y install g++
	apt-get -qq -y install freetype*
	apt-get -qq -y install libpng-dev
	apt-get -qq -y install python-matplotlib

	# ???
	apt-get -qq -y install postgresql-server-dev-9.3
}

# Installs NGINX web server.
prodiguer_setup_nginx()
{
	# Install the NGinx packages.
	apt-get install -qq -y nginx

	# Update nginx configuration.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/web-nginx.conf -O /etc/nginx/nginx.conf
}

# Installs mongodb db server.
# see http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu
prodiguer_setup_mongodb()
{
	# Import the public key used by the package management system.
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

	# Create a list file for MongoDB.
	wget  http://repo.mongodb.org/apt/ubuntu/dists/trusty/mongodb-org.list -O /etc/apt/sources.list.d/mongodb-org-3.0.list

	# Reload local package database.
	apt-get -qq -y update

	# Install the MongoDB packages.
	apt-get install -qq -y mongodb-org
}

# Installs PostgreSQL db server.
prodiguer_setup_postgresql()
{
	# Reload local package database.
	apt-get -qq -y update

	# Install the PostgreSQL packages.
	apt-get install -qq -y postgresql postgresql-contrib

	# Install default configuration.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/db_pg_hba.conf -O /etc/postgresql/9.3/main/pg_hba.conf

	# Start PostgreSQL service.
	service postgresql restart

	# Install client tools.
	apt-get install -qq -y pgadmin3
}

# Installs RabbitMQ server.
prodiguer_setup_rabbitmq()
{
	# Install required libraries.
	apt-get install -qq -y erlang

	# Import the public key used by the package management system.
	wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	apt-key add ./rabbitmq-signing-key-public.asc
	rm -f ./rabbitmq-signing-key-public.asc

	# Install the RabbitMQ packages.
	apt-get install -qq -y rabbitmq-server

	# Initialise configuration.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/mq-rabbit.config -O /etc/rabbitmq/rabbitmq.config

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Set RabbitMQ admin cli.
	wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_4/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
	chmod a+x /usr/local/bin/rabbitmqadmin

	# Import RabbitMQ broker definitions.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/mq-rabbit-broker-definitions.json -O /tmp/prodiguer-rabbitmq-broker.conf
	rabbitmqctl set_user_tags guest administrator
	rabbitmqadmin -q import /tmp/prodiguer-rabbitmq-broker.conf
	rm -f /tmp/prodiguer-rabbitmq-broker.conf

	# Start RabbitMQ service.
	service rabbitmq-server restart
}

