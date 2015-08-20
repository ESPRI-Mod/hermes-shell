# Installs common libraries.
setup_common()
{
	# Ensure machine is upto date.
	yum -q -y upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum -q -y install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql-libs postgresql-devel python-devel postgresql-plpython python-psycopg2
}

# Installs postgres db server.
setup_db_postgres()
{
	echo "TODO - setup_db_postgres"
	# # Install yum -q PostgreSQL repository.
	# rpm ­-ivh $PRODIGUER_DIR_TEMPLATES/other/pgdg-centos94-9.4-1.noarch.rpm

	# # Install PostgreSQL with yum -q package manager.
	# yum -q -y install postgresql-server postgresql

	# # Initialize PostgreSQL server.
	# service postgresql initdb

	# # Setup PostgreSQL service to auto start on system boot.
	# chkconfig postgresql on

	# # Start PostgreSQL service using following command.
	# service postgresql start
}

# Installs mongodb db server.
setup_db_mongo()
{
	wget https://repo.mongodb.org/yum/redhat/mongodb-org.repo /etc/yum.repos.d/mongodb-org.repo
	yum -q -y install mongodb-org
}

# Installs RabbitMQ server.
setup_mq_rabbitmq()
{
	echo "TODO - setup_mq_rabbitmq"
	# # Install dependencies.
	# yum -q -y install erlang

	# # Install RabbitMQ.
	# rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	# wget https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_4/rabbitmq-server-3.5.4-1.noarch.rpm -O $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.4-1.noarch.rpm
	# yum -q -y install $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.4-1.noarch.rpm
	# rm -rf $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.4-1.noarch.rpm

	# # Enable RabbitMQ management plugin.
	# rabbitmq-plugins enable rabbitmq_management

	# # Set RabbitMQ to start on boot and start it up immediately.
	# /sbin/chkconfig rabbitmq-server on
	# /etc/init.d/rabbitmq-server start

	# # Set RabbitMQ admin cli.
	# wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_4/bin/rabbitmqadmin -O $PRODIGUER_DIR_TMP/rabbitmqadmin
	# cp $PRODIGUER_DIR_TMP/rabbitmqadmin /usr/local/bin
	# rm -rf $PRODIGUER_DIR_TMP/rabbitmqadmin
	# chmod a+x /usr/local/bin/rabbitmqadmin

	# # Import RabbitMQ config.
	# rabbitmqctl set_user_tags guest administrator
	# rabbitmqadmin -q import $PRODIGUER_DIR_TEMPLATES/config/mq-rabbit.json

	# # Remove default user.
	# rabbitmqctl delete_user guest
}

# Installs NGINX web server.
setup_web_nginx()
{
	echo "TODO - setup_web_nginx"
	# # Install nginx.
	# rpm -i $PRODIGUER_DIR_TEMPLATES/other/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	# yum -q -y install nginx

	# # Update nginx configuration.
	# cp $PRODIGUER_DIR_TEMPLATES/config/web-nginx.conf /etc/nginx/nginx.conf
}
