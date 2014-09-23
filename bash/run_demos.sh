#!/bin/bash

# ###############################################################
# SECTION: DEMOS
# ###############################################################

# Run demonstration of libigcm message publishing.
run_demo_libigcm_to_mq()
{
    activate_venv server
    python $DIR_DEMOS/monitoring/libigcm_to_mq_server.py $1
}

# Run demonstration of informing API of incoming monitoring messsages.
run_demo_mq_to_api()
{
    activate_venv server
    python $DIR_DEMOS/monitoring/mock_mq_to_api.py
}

# Run demonstration of metric API lifecycle.
run_demo_metric_lifecycle()
{
	declare group_id=TEST_METRIC_GROUP_01
	declare filepath=$DIR_DEMOS/api/metric/test_files/TEST_METRIC_GROUP_01.json
	declare filepath_csv=$DIR_DEMOS/api/metric/test_files/TEST_METRIC_GROUP_01.csv

	# Reset group.
	run_metric_delete $group_id

	# List set of groups.
	run_metric_list

	# Add metricss.
	run_metric_add filepath

	# List set of groups.
	run_metric_list
}
