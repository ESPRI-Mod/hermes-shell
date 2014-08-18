#!/bin/bash

# ###############################################################
# SECTION: HELP
# ###############################################################

# Displays help text to user.
run_help()
{
	helpers=(
		run_help_stack
		run_help_db
		run_help_mq
		run_help_web
		run_help_api_metric
		run_help_tests
		run_help_demos
	)

	log "------------------------------------------------------------------"
	for helper in "${helpers[@]}"
	do
		$helper
		log "------------------------------------------------------------------"
	done
}

run_help_db()
{
	log "DB commands :"
	log "db-backup" 1
	log "performs a backup of database(s)" 2
	log "db-install" 1
	log "initializes database" 2
	log "db-reset" 1
	log "uninstalls & installs database(s)" 2
	log "db-restore" 1
	log "restores database(s)" 2
	log "db-uninstall" 1
	log "drops database(s)" 2

	log "db-server-install" 1
	log "drops database(s)" 2
}

run_help_mq()
{
	log "Message Queue commands :"
	log "mq-consumer TYPE [LIMIT]" 1
	log "runs a message consumer" 2
	log "TYPE = type of consumer to be run" 2
	log "LIMIT = limit of number of messages to consume" 2
	log "mq-producer TYPE [LIMIT]" 1
	log "TYPE = type of producer to be run" 2
	log "LIMIT = limit of number of messages to produce" 2
	log "runs a message producer" 2
	log "mq-mock-libligcm" 1
	log "runs a mock script that simulates libligcm message production" 2
	log "mq-mock-api-notifier" 1
	log "runs a mock script that notifies the web API of incoming messages" 2
}

run_help_web()
{
	log "Web commands :"
	log "web-api" 1
	log "launches web API application" 2
}

run_help_api_metric()
{
	log "Metric web API commands :"
	log "metric-add" 1
	log "adds a group of metrics from either a json or csv file" 2
	log "metric-delete-group" 1
	log "deletes a group of metrics" 2
	log "metric-delete-line" 1
	log "deletes a single metric" 2
	log "metric-fetch" 1
	log "fetches a group of metrics" 2
	log "metric-fetch-line-count" 1
	log "fetches number of lines within a metric group" 2
	log "metric-list-group" 1
	log "list the names of all metric groups" 2
}

run_help_stack()
{
	log "Stack commands :"
	log "stack-bootstrap" 1
	log "prepares system for install " 2
	log "stack-install" 1
	log "installs stack & virtual environments" 2
	log "stack-update" 1
	log "updates stack & virtual environments" 2
	log "stack-update-shell" 1
	log "updates shell only" 2
	log "stack-update-repos" 1
	log "updates git repos only" 2
	log "stack-update-venvs only" 1
	log "updates virtual environments" 2
	log "stack-uninstall" 1
	log "uninstalls stack & virtual environments" 2
}

run_help_tests()
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

run_help_demos()
{
	log "Demo commands :"
	log "demo-libligcm-to-mq" 1
	log "Publishes mock libligcm messages to MQ server" 2
	log "demo-libligcm-to-mq-via-smtp" 1
	log "Publishes libligcm messages pulled from SMTP server to MQ server" 2
	log "demo-mq-to-api" 1
	log "Sends mock MQ notifications to API for routing to front-end via websockets" 2
	log "demo-metric-lifecycle" 1
	log "Demonstrates metric API lifecycle" 2
}