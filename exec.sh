#!/bin/bash

# Set root path.
PRODIGUER_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $PRODIGUER_DIR

# Initialise shell.
source $PRODIGUER_DIR/bash/init.sh

# Invoke action.
$PRODIGUER_ACTION $PRODIGUER_ACTION_ARG1 $PRODIGUER_ACTION_ARG2 $PRODIGUER_ACTION_ARG3 $PRODIGUER_ACTION_ARG4 $PRODIGUER_ACTION_ARG5

# End.
log_banner
exit 0
