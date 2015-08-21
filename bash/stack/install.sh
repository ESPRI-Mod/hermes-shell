#!/bin/bash

# Import utils.
source $PRODIGUER_HOME/bash/init.sh

# Installs virtual environments.
_install_venv()
{
	if [ "$2" ]; then
		log "Installing virtual environment: $1"
	fi

	# Make directory.
	declare TARGET_VENV=$PRODIGUER_DIR_VENV/$1
	rm -rf $TARGET_VENV
    mkdir -p $TARGET_VENV

    # Initialise venv.
    export PATH=$PRODIGUER_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_PYTHON
    virtualenv -q $TARGET_VENV

    # Build dependencies.
    source $TARGET_VENV/bin/activate
	declare TARGET_REQUIREMENTS=$PRODIGUER_DIR_TEMPLATES/venv-requirements-$1.txt
    pip install -q --allow-all-external -r $TARGET_REQUIREMENTS

    # Cleanup.
    deactivate
}

# Installs python virtual environments.
_install_venvs()
{
	for venv in "${PRODIGUER_VENVS[@]}"
	do
		_install_venv $venv "echo"
	done
}

# Installs a python executable primed with setuptools, pip & virtualenv.
_install_python_executable()
{
	# Version of python used by stack.
	declare PYTHON_VERSION=2.7.10

	log "Installing python "$PYTHON_VERSION" (takes approx 2 minutes)"

	# Download source.
	set_working_dir $PRODIGUER_DIR_PYTHON
	mkdir src
	cd src
	wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz --no-check-certificate
	tar -xvf Python-$PYTHON_VERSION.tgz
	rm Python-$PYTHON_VERSION.tgz

	# Compile.
	cd Python-$PYTHON_VERSION
	./configure --prefix=$PRODIGUER_DIR_PYTHON
	make
	make install
	export PATH=$PRODIGUER_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_PYTHON

	# Install setuptools.
	cd $PRODIGUER_DIR_PYTHON/src
	wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
	python ez_setup.py

	# Install pip.
	easy_install --prefix $PRODIGUER_DIR_PYTHON pip

	# Install virtualenv.
	pip install virtualenv
}

# Installs a git repo.
_install_repo()
{
	log "Installing repo: $1"

	rm -rf $PRODIGUER_DIR_REPOS/$1
	git clone -q https://github.com/Prodiguer/$1.git $PRODIGUER_DIR_REPOS/$1
}

# Installs git repos.
_install_repos()
{
	log "Installing repos"

	for repo in "${PRODIGUER_REPOS[@]}"
	do
		_install_repo $repo
	done
}

# Sets up directories.
_install_dirs()
{
	for ops_dir in "${PRODIGUER_OPS_DIRS[@]}"
	do
		mkdir -p $ops_dir
	done
	mkdir -p $PRODIGUER_DIR_REPOS
	mkdir -p $PRODIGUER_DIR_PYTHON
	mkdir -p $PRODIGUER_DIR_TMP
}

# Sets up configuration.
_install_configuration()
{
	cp $PRODIGUER_DIR_TEMPLATES/prodiguer.sh $PRODIGUER_DIR_CONFIG/prodiguer.sh
	cp $PRODIGUER_DIR_TEMPLATES/prodiguer.json $PRODIGUER_DIR_CONFIG/prodiguer.json
	cp $PRODIGUER_DIR_TEMPLATES/mq-supervisord.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
	cp $PRODIGUER_DIR_TEMPLATES/web-supervisord.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf
	cat $PRODIGUER_DIR_TEMPLATES/prodiguer_env_bash_profile.txt >> $HOME/.bash_profile
}

# Sets up script permissions.
_install_script_permissions()
{
	chmod a+x $PRODIGUER_HOME/bash/cv/*.sh
	chmod a+x $PRODIGUER_HOME/bash/db/*.sh
	chmod a+x $PRODIGUER_HOME/bash/mq/*.sh
	chmod a+x $PRODIGUER_HOME/bash/os/*.sh
	chmod a+x $PRODIGUER_HOME/bash/stack/*.sh
	chmod a+x $PRODIGUER_HOME/bash/tests/*.sh
	chmod a+x $PRODIGUER_HOME/bash/web/*.sh
}

# Main entry point.
main()
{
	log "INSTALLING STACK"

	_install_dirs
	_install_configuration
	_install_script_permissions
	_install_repos
	_install_python_executable
	_install_venvs

	log "INSTALLED STACK"
}

# Invoke entry point.
main
