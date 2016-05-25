# Import utils.
source $HERMES_HOME/bash/init.sh

# Delete log files.
rm $PRODIGUER_DIR_LOGS/web/*.log
rm $PRODIGUER_DIR_DAEMONS/web/supervisor.log

log "WEB : reset daemon logs"
