# Import utils.
source $HERMES_HOME/bash/init.sh

# Delete log files.
rm $HERMES_DIR_LOGS/web/std*.log
rm $HERMES_DIR_DAEMONS/web/supervisor.log

log "WEB : reset daemon logs"
