# Installs common libraries.
setup_common()
{
	# Ensure machine is upto date.
	yum upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum -q -y install git xz-libs zlib-devel bzip2-devel gcc-c++ openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql-libs postgresql-devel python-devel postgresql-plpython python-psycopg2 python-matplotlib freetype-devel libpng-devel
}

# Installs postgres db server.
setup_db_postgres()
{
	# Install PostgreSQL.
	yum localinstall http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm
	yum -q -y install postgresql-server postgresql94-contrib postgresql

	# Initialize PostgreSQL database.
	service postgresql initdb

	# Start PostgreSQL service.
	service postgresql start

	# Setup PostgreSQL service to auto start on system boot.
	chkconfig postgresql on
}

# Installs mongodb db server.
setup_db_mongo()
{
	# Install MongoDB.
	wget https://repo.mongodb.org/yum/redhat/mongodb-org.repo -O /etc/yum.repos.d/mongodb-org.repo
	yum -q -y install mongodb-org

	# Start MongoDB service.
	service mongod start
}

# Installs RabbitMQ server.
setup_mq_rabbitmq()
{
	# Install dependencies.
	yum -q -y install erlang

	# Install RabbitMQ.
	rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	yum localinstall https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_4/rabbitmq-server-3.5.4-1.noarch.rpm

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Start RabbitMQ service.
	service rabbitmq-server start

	# Setup RabbitMQ service to auto start on system boot.
	chkconfig rabbitmq-server on

	# Set RabbitMQ admin cli.
	wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_4/bin/rabbitmqadmin -O /usr/local/bin/rabbitmqadmin
	chmod a+x /usr/local/bin/rabbitmqadmin

	# Download RabbitMQ config.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/config/mq-rabbit.json -O /tmp/prodiguer-rabbitmq.conf

	# Import RabbitMQ config.
	rabbitmqctl set_user_tags guest administrator
	rabbitmqadmin -q import /tmp/prodiguer-rabbitmq.conf

	# Remove default user.
	rabbitmqctl delete_user guest

	# Clean up.
	rm -f /tmp/prodiguer-rabbitmq.conf
}

# Installs NGINX web server.
setup_web_nginx()
{
	# Install nginx.
	yum localinstall http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum -q -y install nginx

	# Update nginx configuration.
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/config/web-nginx.conf -O /etc/nginx/nginx.conf
}
