#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/utils.sh

# Main entry point.
main()
{
    log "Installing python ..."

    # Set variables.
    declare PYTHON_VERSION=2.7.12

    log "Installing python "$PYTHON_VERSION" (takes approx 2 minutes)"

    # Reset.
    rm -rf $HERMES_DIR_PYTHON
    mkdir -p $HERMES_DIR_PYTHON

    # Download source.
    cd $HERMES_DIR_PYTHON
    mkdir src
    cd src
    wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz --no-check-certificate
    tar -xvf Python-$PYTHON_VERSION.tgz

    # Compile.
    cd Python-$PYTHON_VERSION
    ./configure --prefix=$HERMES_DIR_PYTHON
    make
    make install
    export PATH=$HERMES_DIR_PYTHON/bin:$PATH
    export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_PYTHON
    export PYTHONPATH=$PYTHONPATH:$HERMES_DIR_PYTHON/lib/python2.7/site-packages

    # Install setuptools.
    cd $HERMES_DIR_PYTHON/src
    wget https://bootstrap.pypa.io/ez_setup.py
    python ez_setup.py

    # Install & upgrade pip / virtual env.
    easy_install --prefix $HERMES_DIR_PYTHON pip
    pip install --upgrade pip
    pip install --upgrade virtualenv

    # Clean up.
    cd $HERMES_DIR_PYTHON
    rm -rf ./src
}

# Invoke entry point.
main
