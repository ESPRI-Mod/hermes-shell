# Sets up RabbitMQ server.
_setup_rabbitmq()
{
	# Install dependencies.
	yum -q -y install erlang

	# Install RabbitMQ.
	rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	wget https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v3_5_3/rabbitmq-server-3.5.3-1.noarch.rpm -O $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.3-1.noarch.rpm
	yum -q -y install $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.3-1.noarch.rpm
	rm -rf $PRODIGUER_DIR_TMP/rabbitmq-server-3.5.3-1.noarch.rpm

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Set RabbitMQ to start on boot and start it up immediately.
	/sbin/chkconfig rabbitmq-server on
	/etc/init.d/rabbitmq-server start

	# Set RabbitMQ admin cli.
	wget https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v3_5_3/bin/rabbitmqadmin -O $PRODIGUER_DIR_TMP/rabbitmqadmin
	cp $PRODIGUER_DIR_TMP/rabbitmqadmin /usr/local/bin
	rm -rf $PRODIGUER_DIR_TMP/rabbitmqadmin
	chmod a+x /usr/local/bin/rabbitmqadmin

	# Import RabbitMQ config.
	rabbitmqctl set_user_tags guest administrator
	rabbitmqadmin -q import $PRODIGUER_DIR_TEMPLATES/config/mq-rabbit.json

	# Remove default user.
	rabbitmqctl delete_user guest
}

# Main entry point.
main()
{
	# Install rabbit mq server.
	_setup_rabbitmq
}

# Invoke entry point.
main
