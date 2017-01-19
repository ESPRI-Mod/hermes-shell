# Import utils.
source $HERMES_HOME/bash/utils.sh

# Replace supervisord configuarion.
cp $HERMES_DIR_TEMPLATES/web-supervisord.conf $HERMES_DIR_DAEMONS/web/supervisord.conf

log "WEB : updated daemons config"
