# Installs common libraries.
setup_common()
{
	# Ensure machine is upto date.
	yum -q -y upgrade

	# Enable EPEL v7.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

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
	yum -q -y install postgresql-libs
	yum -q -y install postgresql-devel
	yum -q -y install python-devel
	yum -q -y install postgresql-plpython
	yum -q -y install python-psycopg2
	yum -q -y install pgadmin3
	yum -q -y install gcc-c++
	yum -q -y install freetype-devel
	yum -q -y install libpng-devel
	yum -q -y install python-matplotlib
}}

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
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/mq-rabbit.json -O /tmp/prodiguer-rabbitmq.conf

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
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/templates/web-nginx.conf -O /etc/nginx/nginx.conf
}
