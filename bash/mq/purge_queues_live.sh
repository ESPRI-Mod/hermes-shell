#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
	# Set of supported debug MQ queues.
	declare -a QUEUES=(
		'live-alert'
		'live-cv'
		'live-fe'
		'live-metrics-conso'
		'live-metrics-env'
		'live-metrics-pcmdi'
		'live-monitoring-compute'
		'live-monitoring-post-processing'
		'live-smtp'
		'live-superviseur'
	)


	for queue in "${QUEUES[@]}"
	do
		log "MQ : purging live queue :: "$queue
		rabbitmqadmin -q -u hermes-mq-admin -p $1 -V hermes purge queue name=$queue
	done

	log "MQ : purged live queues"
}

# Invoke entry point.
main $1