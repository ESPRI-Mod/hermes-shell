#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing system dependencies"
    yum install gcc libffi-devel python-devel openssl-devel

    log "Installing python ..."

    # Set variables.
    declare PYTHON_VERSION=2.7.13

    log "Installing python "$PYTHON_VERSION" (takes approx 2 minutes)"

    # Reset.
    rm -rf $HERMES_DIR_PYTHON
    mkdir -p $HERMES_DIR_PYTHON/src

    # Download source.
    cd $HERMES_DIR_PYTHON/src
    wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz --no-check-certificate
    tar -xvf ./Python-$PYTHON_VERSION.tgz

    # Compile.
    cd Python-$PYTHON_VERSION
    ./configure --prefix=$HERMES_DIR_PYTHON
    make
    make install

    # Update paths.
    export PATH=$HERMES_DIR_PYTHON/bin:$PATH
    export PYTHONPATH=$HERMES_DIR_PYTHON/bin:$PYTHONPATH
    export PYTHONPATH=$HERMES_DIR_PYTHON/lib/python2.7/site-packages:$PYTHONPATH

    # Install setuptools.
    cd $HERMES_DIR_PYTHON/src
    wget http://bootstrap.pypa.io/ez_setup.py
    python ez_setup.py

    # Install & upgrade pip / virtual env.
    easy_install --prefix $HERMES_DIR_PYTHON pip virtualenv
}

# Invoke entry point.
main
