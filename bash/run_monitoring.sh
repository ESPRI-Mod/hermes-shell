#!/bin/bash

# ###############################################################
# SECTION: MONITORING
# ###############################################################

# Set of supported monitoring scenarios.
declare -a monitoring_scenarios=(
	'01'
)

run_monitoring_dispatch_test_emails()
{
	activate_venv server
	for scenario in "${monitoring_scenarios[@]}"
	do
		log "Monitoring scenario $scenario emails being dispatched ..."
		log "Monitoring scenario $scenario folder: "$DIR_DOCS/mq/simulation_$scenario
	   	python $DIR_DEMOS/mq/send_simulation_monitoring_emails.py $DIR_DOCS/mq/simulation_$scenario
	done
}
