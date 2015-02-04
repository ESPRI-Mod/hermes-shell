#!/bin/bash

# Set root path.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Initialise shell.
source $DIR/bash/init.sh

# Invoke action.
$ACTION $ACTION_ARG $ACTION_SUBARG1 $ACTION_SUBARG2 $ACTION_SUBARG3 $ACTION_SUBARG4

# End.
log_banner
exit 0
