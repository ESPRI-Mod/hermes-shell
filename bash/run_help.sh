#!/bin/bash

# ###############################################################
# SECTION: HELP
# ###############################################################

# Displays help text to user.
run_help()
{
	helpers=(
		run_api_help
		run_db_help
		run_metric_help
		run_mq_help
		run_stack_help
		run_tests_help
	)

	log "------------------------------------------------------------------"
	for helper in "${helpers[@]}"
	do
		$helper
		log "------------------------------------------------------------------"
	done
}

run_api_help()
{
	log "Web API commands :"
	log "api" 1
	log "launches API" 2
}

run_help_api()
{
	run_api_help
}

run_db_help()
{
	log "DB commands :"
	log "db-backup" 1
	log "performs a backup of database" 2
	log "db-install" 1
	log "installs database intiialised with setup data" 2
	log "db-reset" 1
	log "uninstalls & installs database" 2
	log "db-restore" 1
	log "restores database from backup" 2
	log "db-uninstall" 1
	log "drops database" 2
	log "db-server-install" 1
	log "installs postgres db server" 2
}

run_help_db()
{
	run_db_help
}

run_metric_help()
{
	log "Metric web API commands :"
	log "metric-add FILEPATH" 1
	log "adds a group of metrics from either a json or csv file" 2
	log "metric-delete GROUP-ID" 1
	log "deletes a group of metrics" 2
	log "metric-delete-line LINE_ID" 1
	log "deletes one or many metric lines" 2
	log "metric-fetch GROUP-ID" 1
	log "fetches a group of metrics" 2
	log "metric-fetch-columns GROUP-ID" 1
	log "fetches list of metric group columns" 2
	log "metric-fetch-setup GROUP-ID" 1
	log "fetches a metric group's distinct column values" 2
	log "metric-fetch-count GROUP-ID" 1
	log "fetches number of lines within a metric group" 2
	log "metric-lifecycle-demo" 1
	log "demonstrates full metric API lifecycle" 2
	log "metric-list" 1
	log "lists all metric group names" 2
}

run_help_metric()
{
	run_metric_help
}

run_mq_help()
{
	log "Message Queue commands :"
	log "mq-configure" 1
	log "uploads RabbitMQ configuration file to RabbitMQ server" 2
	log "mq-consumer TYPE [THROTTLE]" 1
	log "runs a message consumer" 2
	log "TYPE = type of consumer to be run" 2
	log "THROTTLE = optional limit of number of messages to consume" 2
	log "mq-consumers" 1
	log "runs all message consumers in dedicated processes" 2
	log "mq-producer TYPE [THROTTLE]" 1
	log "runs a message producer" 2
	log "TYPE = type of producer to be run" 2
	log "THROTTLE = optional limit of number of messages to produce" 2
	log "mq-purge" 1
	log "deletes all messages from all queues" 2
	log "mq-reset" 1
	log "deletes all vhosts, exhanges, queues and users from RabbitMQ server" 2
	log "mq-server" 1
	log "launches RabbitMq server" 2
}

run_help_mq()
{
	run_mq_help
}

run_stack_help()
{
	log "Stack commands :"
	log "stack-bootstrap" 1
	log "prepares system for install " 2
	log "stack-install" 1
	log "installs stack & virtual environments" 2
	log "stack-update" 1
	log "updates full stack (i.e. repos, config and virtual environments)" 2
	log "stack-update-shell" 1
	log "updates shell" 2
	log "stack-update-repos" 1
	log "updates git repos" 2
	log "stack-update-venvs" 1
	log "updates virtual environments" 2
	log "stack-uninstall" 1
	log "uninstalls stack & virtual environments" 2
}

run_help_stack()
{
	run_stack_help
}

run_tests_help()
{
	log "Unit test commands :"
	log "tests" 1
	log "runs all unit tests" 2

	log "tests-api" 1
	log "runs all api unit tests" 2
	log "tests-api-utils-ep" 1
	log "runs api endpoint unit tests" 2
	log "tests-api-utils-ws" 1
	log "runs api web-socket unit tests" 2
	log "tests-api-metric" 1
	log "runs api simulation metrics unit tests" 2

	log "tests-cv" 1
	log "runs controlled vocabulary unit tests" 2

	log "tests-db" 1
	log "runs all database unit tests" 2
	log "tests-db-main" 1
	log "runs main database unit tests" 2
	log "tests-db-mq-hooks" 1
	log "runs message queue to database unit tests" 2
	log "tests-db-types" 1
	log "runs database types unit tests" 2

	log "tests-mq" 1
	log "runs message queue unit tests" 2

	log "tests-utils-convert" 1
	log "runs conversion utility unit tests" 2
	log "tests-utils-config" 1
	log "runs configuration utility unit tests" 2
}

run_help_tests()
{
	run_tests_help
}

