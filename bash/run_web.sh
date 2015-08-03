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

    log "WEB : initialized daemons"
}

# Kills WEB daemon process.
run_web_daemons_kill()
{
    activate_venv server

 	 supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
     supervisorctl -c $DIR_DAEMONS/web/supervisord.conf shutdown

    log "WEB : killed daemons"
}

# Restarts WEB daemons.
run_web_daemons_refresh()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf update all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all

    log "WEB : refreshed daemons"
}

# Resets WEB daemon logs.
run_web_daemons_reset_logs()
{
    rm $DIR_LOGS/web/*.log
    rm $DIR_DAEMONS/web/supervisord.log

    log "WEB : reset daemon logs"
}

# Restarts WEB daemons.
run_web_daemons_restart()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf stop all
    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all

    log "WEB : restarted daemons"
}

# Launches WEB daemons.
run_web_daemons_start()
{
    activate_venv server

    supervisorctl -c $DIR_DAEMONS/web/supervisord.conf start all

    log "WEB : started daemons"
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

    log "WEB : stopped daemons"
}

# Updates the web supervisord config file.
run_web_daemons_update_config()
{
    cp $DIR_TEMPLATES/config/web-supervisord.conf $DIR_DAEMONS/web/supervisord.conf

    log "WEB : updated daemons config"
}
