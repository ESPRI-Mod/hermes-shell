#!/bin/bash

# ###############################################################
# SECTION: DEMOS
# ###############################################################

# Runs set of demos.
run_demo()
{
    # Set folder paths.
    DIR_SERVER=$DIR_REPOS/prodiguer-server
    DIR_SERVER_DEMOS=$DIR_REPOS/prodiguer-server/demos

    # Extend python path.
    export PYTHONPATH=$PYTHONPATH:$DIR_SERVER

    # Activate server venv.
    activate_venv server

    # Run demo(s).
    if [ $1 = "monitoring-mock-mq-to-api" ]; then
        python $DIR_SERVER_DEMOS/monitoring/mock_mq_to_api.py
    elif [ $1 = "metric-lifecycle" ]; then
        python $DIR_SERVER_DEMOS/metric/lifecycle.py $2 $3
	fi
}