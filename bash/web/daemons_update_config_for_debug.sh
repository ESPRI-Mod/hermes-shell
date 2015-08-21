# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Replace supervisord configuarion.
cp $PRODIGUER_DIR_TEMPLATES/web-supervisord-debug.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

log "WEB : updated daemons config for debugging"
