help_utest()
{
	log "utest-all" 1
	log "runs all unit tests" 2
	log

	log "utest-web-api" 1
	log "runs api unit tests" 2
	log

	log "utest-web-api-utils-ws" 1
	log "runs api web-socket unit tests" 2
	log

	log "utest-metric" 1
	log "runs api simulation metrics unit tests" 2

	log "utest-cv" 1
	log "runs controlled vocabulary unit tests" 2

	log "utest-db" 1
	log "runs all database unit tests" 2
	log

	log "utest-db-main" 1
	log "runs main database unit tests" 2
	log

	log "utest-db-mq-hooks" 1
	log "runs message queue to database unit tests" 2
	log

	log "utest-db-types" 1
	log "runs database types unit tests" 2

	log "utest-mq" 1
	log "runs message queue unit tests" 2

	log "utest-utils-convert" 1
	log "runs conversion utility unit tests" 2
	log

	log "utest-utils-config" 1
	log "runs configuration utility unit tests" 2
}