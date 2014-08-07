#!/bin/bash

# ###############################################################
# SECTION: DEMOS
# ###############################################################

# Run demonstration of libligcm message publishing.
run_demo_libligcm_to_mq()
{
    activate_venv server
    python $DIR_SERVER_DEMOS/monitoring/libligcm_to_mq_server.py $1
}

# Run demonstration of libligcm message publishing via an SMTP bridge.
run_demo_libligcm_to_mq_via_smtp()
{
    activate_venv server
    python $DIR_SERVER_DEMOS/monitoring/libligcm_to_mq_server_via_smtp.py
}

# Run demonstration of informing API of incoming monitoring messsages.
run_demo_mq_to_api()
{
    activate_venv server
    python $DIR_SERVER_DEMOS/monitoring/mock_mq_to_api.py
}

# Run demonstration of metric API lifecycle.
run_demo_metric_lifecycle()
{
    activate_venv server
    python $DIR_SERVER_DEMOS/metric/lifecycle.py $1 $2
}

# Run demonstration of metric API lifecycle.
run_demo_consume_xin_log()
{
    activate_venv server
    python $DIR_SERVER_DEMOS/monitoring/consume_xin_log.py
}