# Import utils.
source $HERMES_HOME/bash/init.sh

# Replace supervisord configuarion.
cp $PRODIGUER_DIR_TEMPLATES/web-supervisord.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

log "WEB : updated daemons config"
