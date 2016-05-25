# Import utils.
source $HERMES_HOME/bash/init.sh

# Delete log files.
rm $PRODIGUER_DIR_LOGS/mq/*.log
rm $PRODIGUER_DIR_DAEMONS/mq/supervisor.log

log "MQ : reset daemon logs"
