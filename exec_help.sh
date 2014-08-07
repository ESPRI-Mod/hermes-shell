#!/bin/bash

# ###############################################################
# SECTION: HELP
# ###############################################################

# Displays help text to user.
run_help()
{
	log "General commands :"
	log "boostrap" 1
	log "prepares system for install " 2
	log "install" 1
	log "installs shell, git repos & virtual environments" 2
	log "update" 1
	log "updates shell, git repos & virtual environments" 2
	log "uninstall" 1
	log "uninstalls shell, git repos & virtual environments" 2

	log ""
	log "API commands :"
	log "run-api" 1
	log "launches api web application" 2
	log "run-api-tests" 1
	log "executes api automated tests" 2

	log ""
	log "DB commands :"
	log "run-db-install" 1
	log "initializes database" 2
	log "run-db-backup" 1
	log "performs a backup of database(s)" 2
	log "run_db_reset" 1
	log "uninstalls & installs database(s)" 2
	log "run-db-restore" 1
	log "restores database(s)" 2
	log "run-db-uninstall" 1
	log "drops database(s)" 2
	log "run-db-server-install" 1
	log "drops database(s)" 2

	log ""
	log "Demo commands :"
	log "demo-libligcm-to-mq" 1
	log "Publishes mock libligcm messages to MQ server" 2
	log "demo-libligcm-to-mq-via-smtp" 1
	log "Publishes libligcm messages pulled from SMTP server to MQ server" 2
	log "demo-mq-to-api" 1
	log "Sends mock MQ notifications to API for routing to front-end via websockets" 2
	log "demo-metric-lifecycle" 1
	log "Demonstrates metric API lifecycle" 2

	log ""
	log "Automated test commands :"
	log "run-tests" 1
	log "runs full set of automated tests" 2
	log "options as follows:" 2
	log "api-utils-ep: run api endpoint tests" 3
	log "api-utils-ws: run api web-socket tests" 3
	log "api-metric: run api simulation metrics tests" 3
	log "cv: run controlled vocabulary tests" 3
	log "db: run database tests" 3
	log "db-main: run main database tests" 3
	log "db-mq-hooks: run message queue to database tests" 3
	log "db-types: run database types tests" 3
	log "mq: run message queue tests" 3
	log "u-convert: run conversion utility tests" 3
	log "u-config: run configuration utility tests" 3
}
