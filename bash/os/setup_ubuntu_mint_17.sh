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
}

# Installs NGINX web server.
prodiguer_setup_nginx()
{
	echo "TODO: prodiguer_setup_common"
}

# Installs mongodb db server.
prodiguer_setup_mongodb()
{
	echo "TODO: prodiguer_setup_common"
}

# Installs postgres db server.
prodiguer_setup_postgresql()
{
	echo "TODO: prodiguer_setup_common"
}

# Installs RabbitMQ server.
prodiguer_setup_rabbitmq()
{
	echo "TODO: prodiguer_setup_common"
}
