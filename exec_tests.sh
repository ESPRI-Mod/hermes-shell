#!/bin/bash

# ###############################################################
# SECTION: TESTS
# ###############################################################

# Runs set of tests.
run_tests()
{
	# Set test folder paths.
	DIR_SERVER_TESTS=$DIR_REPOS/prodiguer-server/tests	
	export PYTHONPATH=$PYTHONPATH:$DIR_SERVER_TESTS

	# Activate server venv.
	activate_venv server

	# Run all test(s).
	if [ -z "$1" ]; then
	    log "TESTS: executing all tests ..."
		nosetests -v -s $DIR_SERVER_TESTS
	elif [ $1 = "all" ]; then
	    log "TESTS: executing all tests ..."
		nosetests -v -s $DIR_SERVER_TESTS

	# Run main test(s).
	elif [ $1 = "main" ]; then
		log "TESTS: executing main tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_main.py

	# Run API tests.
	elif [ $1 = "api" ]; then
	    log "TESTS: executing api utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_api_utils_ep.py
		nosetests -v -s $DIR_SERVER_TESTS/test_api_utils_ws.py
		nosetests -v -s $DIR_SERVER_TESTS/test_api_metric.py
	elif [ $1 = "api-utils-ep" ]; then
	    log "TESTS: executing api endpoint utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_api_utils_ep.py
	elif [ $1 = "api-utils-ws" ]; then
	    log "TESTS: executing api websocket utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_api_utils_ws.py
	elif [ $1 = "api-metric" ]; then
	    log "TESTS: executing api simulation metrics tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_api_metric.py

	# Run CV tests.
	elif [ $1 = "cv" ]; then
	    log "TESTS: executing cv tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_cv.py

	# Run DB tests.
	elif [ $1 = "db" ]; then
	    log "TESTS: executing db tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_db_main.py
		nosetests -v -s $DIR_SERVER_TESTS/test_db_mq_hooks.py
		nosetests -v -s $DIR_SERVER_TESTS/test_db_types.py
	elif [ $1 = "db-main" ]; then
	    log "TESTS: executing db main tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_db_main.py
	elif [ $1 = "db-mq-hooks" ]; then
	    log "TESTS: executing db to mq hooks tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_db_mq_hooks.py
	elif [ $1 = "db-types" ]; then
	    log "TESTS: executing db types tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_db_types.py

	# Run MQ tests.
	elif [ $1 = "mq" ]; then
	    log "TESTS: executing mq tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_mq.py

	# Run utility functions tests.
	elif [ $1 = "u" ]; then
	    log "TESTS: executing utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_utils_convert.py
		nosetests -v -s $DIR_SERVER_TESTS/test_utils_config.py
	elif [ $1 = "u-convert" ]; then
	    log "TESTS: executing convert utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_utils_convert.py
	elif [ $1 = "u-config" ]; then
	    log "TESTS: executing config utils tests ..."
		nosetests -v -s $DIR_SERVER_TESTS/test_utils_config.py
	fi	
}