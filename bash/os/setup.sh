source $PRODIGUER_HOME/bash/init.sh

# Parses operating system type name.
_parse_os_type()
{
	declare -a types=(
		'centos-6'
		'centos-7'
		'scientific-linux-6'
		'scientific-linux-7'
		'ubuntu-mint-17'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Parses machine type name.
_parse_machine_type()
{
	declare -a types=(
		'db'
		'dev'
		'mq'
		'web'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Sets up operating system so that prodiguer stack can execute.
main()
{
	# Escape if operating system type is unsupported.
	declare os_type=$(_parse_os_type $1)
	if [ $os_type = 'UNKNOWN' ]; then
		log "Operating system ($1) is unsupported"
		exit
	fi

	# Escape if machine type is unsupported.
	declare machine_type=$(_parse_machine_type $2)
	if [ $machine_type = 'UNKNOWN' ]; then
		log "Machine type ($2) is unsupported"
		exit
	fi

	# Activate setup functions.
	source $PRODIGUER_DIR_BASH/os/setup_`echo $os_type | tr '[:upper:]' '[:lower:]' | tr '-' '_'`.sh

	# Setup common libraries.
	log "installing common libraries ..."
	setup_common
	log "installed common libraries ..."

	# Setup DB server.
	if [ $machine_type = "db" ] || [ $machine_type = "dev" ] ; then
		# ... PostgreSQL
		log "installing PostgreSQL ..."
		setup_db_postgres
		log "installed PostgreSQL ..."
		# ... MongoDB
		log "installing MongoDB ..."
		setup_db_mongo
		log "installed MongoDB ..."
	fi

	# Setup MQ server.
	if [ $machine_type = "mq" ] || [ $machine_type = "dev" ] ; then
		# ... RabbitMQ
		log "installing RabbitMQ ..."
		setup_mq_rabbitmq
		log "installed RabbitMQ ..."
	fi

	# Setup web server.
	if [ $machine_type = "web" ] || [ $machine_type = "dev" ] ; then
		# ... nginx
		log "installing nginx ..."
		setup_web_nginx
		log "installed nginx ..."
	fi
}

# Invoke entry point.
main $1 $2
