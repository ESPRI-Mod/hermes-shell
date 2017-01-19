#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing configuration ..."

    cp $HERMES_DIR_TEMPLATES/hermes.json $HERMES_DIR_CONFIG/hermes.json
    cp $HERMES_DIR_TEMPLATES/mq-supervisord-$HERMES_DEPLOYMENT_MODE.conf $HERMES_DIR_DAEMONS/mq/supervisord.conf
    cp $HERMES_DIR_TEMPLATES/web-supervisord.conf $HERMES_DIR_DAEMONS/web/supervisord.conf
}

# Invoke entry point.
main
