#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Main entry point.
main()
{
	# Set test folder paths.
	HERMES_DIR_SERVER_TESTS=$HERMES_DIR_REPOS/prodiguer-server/tests
	export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_SERVER_TESTS

	# Activate server venv.
	activate_venv server

	# Run all test(s).
	if [ -z "$1" ]; then
	    log "TESTS: executing all tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS
	elif [ $1 = "all" ]; then
	    log "TESTS: executing all tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS

	# Run main test(s).
	elif [ $1 = "main" ]; then
		log "TESTS: executing main tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_main.py

	# Run web service tests.
	elif [ $1 = "web" ]; then
	    log "TESTS: executing web service tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_api_utils_ep.py
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_api_utils_ws.py
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_api_metric.py
	elif [ $1 = "web-utils-ep" ]; then
	    log "TESTS: executing web service endpoint tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_web_utils_ep.py
	elif [ $1 = "web-utils-ws" ]; then
	    log "TESTS: executing web socket tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_web_utils_ws.py
	elif [ $1 = "web-sim-metrics" ]; then
	    log "TESTS: executing simulation metrics web service  tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_web_sim_metrics.py

	# Run CV tests.
	elif [ $1 = "cv" ]; then
	    log "TESTS: executing cv tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_cv.py

	# Run DB tests.
	elif [ $1 = "db" ]; then
	    log "TESTS: executing db tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_main.py
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_mq_hooks.py
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_types.py
	elif [ $1 = "db-main" ]; then
	    log "TESTS: executing db main tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_main.py
	elif [ $1 = "db-mq-hooks" ]; then
	    log "TESTS: executing db to mq hooks tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_mq_hooks.py
	elif [ $1 = "db-types" ]; then
	    log "TESTS: executing db types tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_db_types.py

	# Run MQ tests.
	elif [ $1 = "mq" ]; then
	    log "TESTS: executing mq tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_mq.py

	# Run MQ tests.
	elif [ $1 = "mq-mock-producers" ]; then
	    log "TESTS: executing mq mock producer tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_mq_mock_producers.py

	# Run utility functions tests.
	elif [ $1 = "u" ]; then
	    log "TESTS: executing utils tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_utils_convert.py
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_utils_config.py
	elif [ $1 = "u-convert" ]; then
	    log "TESTS: executing convert utils tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_utils_convert.py
	elif [ $1 = "u-config" ]; then
	    log "TESTS: executing config utils tests ..."
		nosetests -v -s $HERMES_DIR_SERVER_TESTS/test_utils_config.py
	fi
}

# Invoke entry point.
main $1
