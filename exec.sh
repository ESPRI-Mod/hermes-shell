#!/bin/bash

# Set root path.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Import associated scripts.
source $DIR/exec_init.sh
source $DIR/exec_api.sh
source $DIR/exec_api_metric.sh
source $DIR/exec_centos.sh
source $DIR/exec_db.sh
source $DIR/exec_demo.sh
source $DIR/exec_help.sh
source $DIR/exec_install.sh
source $DIR/exec_other.sh
source $DIR/exec_tests.sh


# Invoke action.
$ACTION $ACTION_ARG $ACTION_SUBARG1 $ACTION_SUBARG2

# End.
log_banner
exit 0