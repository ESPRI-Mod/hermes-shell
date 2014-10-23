# ###############################################################
# SECTION: API MONITORING
# ###############################################################

run_monitor_simulation()
{
	activate_venv server
	python $DIR_JOBS/api/monitoring/run_monitor_simulation.py --simulation_uid=$1
}
