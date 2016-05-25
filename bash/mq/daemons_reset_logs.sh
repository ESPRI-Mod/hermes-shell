# Import utils.
source $HERMES_HOME/bash/init.sh

# Delete log files.
rm $HERMES_DIR_LOGS/mq/*.log
rm $HERMES_DIR_DAEMONS/mq/supervisor.log

log "MQ : reset daemon logs"
