# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Delete log files.
rm $PRODIGUER_DIR_LOGS/mq/*.log
rm $PRODIGUER_DIR_DAEMONS/mq/supervisord.log

log "MQ : reset daemon logs"
