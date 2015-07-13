#!/bin/bash

# ###############################################################
# SECTION: API OPS
# ###############################################################

# Run api.
run_web_api()
{
    log "Launching API"

	activate_venv server

	python $DIR_JOBS/web/run_api.py
}

# Initializes WEB daemon.
run_web_daemons_init()
{
    run_web_daemons_reset_logs

    activate_venv server

    supervisord -c $DIR_DAEMONS/web/supervisord.conf
}

# Kills WEB daemon process.
run_web_daemons_kill()
{
    activate_venv server

 	 supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
     supervisorctl -c $DIR_DAEMONS/web/supervisord.conf shutdown
}

# Restarts WEB daemons.
run_web_daemons_refresh()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf update all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all
}

# Resets WEB daemon logs.
run_web_daemons_reset_logs()
{
    rm $DIR_LOGS/web/*.log
}

# Restarts WEB daemons.
run_web_daemons_restart()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all
}

# Launches WEB daemons.
run_web_daemons_start()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all
}

# Launches WEB daemons.
run_web_daemons_status()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf status all
}

# Launches WEB daemons.
run_web_daemons_stop()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
}

# Updates the web supervisord config file.
run_web_daemons_update_config()
{
    cp $DIR_TEMPLATES/config/web-supervisord.conf $DIR_DAEMONS/web/supervisord.conf
}