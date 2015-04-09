# Sets up RabbitMQ server.
_setup_rabbitmq()
{
	# Install dependencies.
	yum install erlang

	# Install RabbitMQ.
	rpm --import http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
	rpm -Uvh http://www.rabbitmq.com/releases/rabbitmq-server/v3.5.1/rabbitmq-server-3.5.1-1.noarch.rpm

	# Enable RabbitMQ management plugin.
	rabbitmq-plugins enable rabbitmq_management

	# Set RabbitMQ to start on boot and start it up immediately.
	/sbin/chkconfig rabbitmq-server on
	/etc/init.d/rabbitmq-server start

	# Set RabbitMQ admin cli.
	wget http://hg.rabbitmq.com/rabbitmq-management/raw-file/rabbitmq_v3_5_1/bin/rabbitmqadmin -O /opt/prodiguer/ops/tmp/rabbitmqadmin
	cp /opt/prodiguer/ops/tmp/rabbitmqadmin /usr/local/bin
	rm -rf /opt/prodiguer/ops/tmp/rabbitmqadmin

	# Import RabbitMQ config.
	rabbitmqadmin -q import $DIR_TEMPLATES/config/rabbitmq.json

	# Delete obsolete MQ server resources.
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
