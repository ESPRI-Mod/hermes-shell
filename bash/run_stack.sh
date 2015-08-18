#!/bin/bash

# ###############################################################
# SECTION: BOOTSTRAP
# ###############################################################

# Boostraps environment variables.
run_stack_bootstrap_environment_variables()
{
	log "Bootstrapping environment variables"

	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer_env.sh $HOME/.prodiguer_server
	cat $PRODIGUER_DIR_TEMPLATES/config/prodiguer_env_bash_profile.txt >> $HOME/.bash_profile

	log "*******************************************************************************"
	log "IMPORTANT NOTICE !!!"
	log "*******************************************************************************"
	log "1.  Review environment variables file:" 1
	log "$HOME/.prodiguer_server" 2
	log ""
	log "2.  Review bash settings (see end of file):" 1
	log "$HOME/.bash_profile" 2
	log ""
	log "*******************************************************************************"
}

# Run stack bootstrapper.
run_stack_bootstrap()
{
	log "BOOTSTRAP STARTS"
	set_working_dir

	log "Initializing ops directories"
	for ops_dir in "${PRODIGUER_OPS_DIRS[@]}"
	do
		mkdir -p $ops_dir
	done

	log "Initializing configuration"
	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer.sh $PRODIGUER_DIR_CONFIG/prodiguer.sh
	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer.json $PRODIGUER_DIR_CONFIG/prodiguer.json
	cp $PRODIGUER_DIR_TEMPLATES/config/mq-supervisord.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
	cp $PRODIGUER_DIR_TEMPLATES/config/web-supervisord.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf
	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer_env.sh $HOME/.prodiguer_server
	cat $PRODIGUER_DIR_TEMPLATES/config/prodiguer_env_bash_profile.txt >> $HOME/.bash_profile

	log "BOOTSTRAP ENDS"

	log "*******************************************************************************"
	log "IMPORTANT NOTICE !!!"
	log "*******************************************************************************"
	log "1.  Review environment variables file:" 1
	log "$HOME/.prodiguer_server" 2
	log ""
	log "2.  Review bash settings (see end of file):" 1
	log "$HOME/.bash_profile" 2
	log ""
	log "*******************************************************************************"
}

# ###############################################################
# SECTION: INSTALL
# ###############################################################

# Display post install notice.
_install_notice()
{
	log
	log "IMPORTANT NOTICE"
	log "Activate prodiguer commands by adding the following line to your settings (e.g. $HOME/.bash_profile)" 1
	log "source $PRODIGUER_DIR/activate.sh" 2
	log "IMPORTANT NOTICE ENDS"
}


# Installs virtual environments.
run_stack_install_venv()
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
	declare TARGET_REQUIREMENTS=$PRODIGUER_DIR_TEMPLATES/venv/requirements-$1.txt
    pip install -q --allow-all-external -r $TARGET_REQUIREMENTS

    # Cleanup.
    deactivate
}

# Installs python virtual environments.
run_stack_install_venvs()
{
	for venv in "${PRODIGUER_VENVS[@]}"
	do
		run_stack_install_venv $venv "echo"
	done
}

# Installs a python executable primed with setuptools, pip & virtualenv.
run_stack_install_python()
{
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
run_stack_install_repo()
{
	log "Installing repo: $1"

	rm -rf $PRODIGUER_DIR_REPOS/$1
	git clone -q https://github.com/Prodiguer/$1.git $PRODIGUER_DIR_REPOS/$1
}

# Installs git repos.
run_stack_install_repos()
{
	for repo in "${PRODIGUER_REPOS[@]}"
	do
		run_install_repo $repo
	done
}

# Sets up directories.
_install_dirs()
{
	mkdir -p $PRODIGUER_DIR_REPOS
	mkdir -p $PRODIGUER_DIR_PYTHON
	mkdir -p $PRODIGUER_DIR_TMP
}

# Installs stack.
run_stack_install()
{
	log "INSTALLING STACK"

	_install_dirs
	run_stack_install_repos
	run_stack_install_python
	run_stack_install_venvs

	log "INSTALLED STACK"

	_install_notice
}


# ###############################################################
# SECTION: UPDATE
# ###############################################################

# Display post update notice.
_update_notice()
{
	log
	log "IMPORTANT NOTICE"
	log "The update process installed new config files.  The old config files are:" 1
	log "$PRODIGUER_DIR_CONFIG/prodiguer-backup.json" 2
	log "$PRODIGUER_DIR_CONFIG/prodiguer-backup.sh" 2
	log "If the config schema version of the new and existing config files is different then you will need to update your local settings accordingly." 1
	log "IMPORTANT NOTICE ENDS"
}

# Upgrades a virtual environment.
run_stack_upgrade_venv()
{
	log "Upgrading virtual environment :: $1"

	declare TARGET_VENV=$PRODIGUER_DIR_VENV/$1
	declare TARGET_VENV_REQUIREMENTS=$PRODIGUER_DIR_TEMPLATES/venv/requirements-$1.txt
    source $TARGET_VENV/bin/activate
    pip install -q --allow-all-external --upgrade -r $TARGET_VENV_REQUIREMENTS
}

# Upgrades virtual environments.
run_stack_upgrade_venvs()
{
	export PATH=$PRODIGUER_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_PYTHON
	for venv in "${PRODIGUER_VENVS[@]}"
	do
		run_stack_upgrade_venv $venv
	done
}

# Updates a virtual environment.
run_stack_update_venv()
{
	log "Updating virtual environment :: $1"

	_uninstall_venv $1
	run_stack_install_venv $1
}

# Updates virtual environments.
run_stack_update_venvs()
{
	export PATH=$PRODIGUER_DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_DIR_PYTHON
	for venv in "${PRODIGUER_VENVS[@]}"
	do
		run_stack_update_venv $venv
	done
}

# Updates a git repo.
run_stack_update_repo()
{
	log "Updating repo: $1"

	set_working_dir $PRODIGUER_DIR_REPOS/$1
	git pull -q
	remove_files "*.pyc"
	set_working_dir
}

# Updates git repos.
run_stack_update_repos()
{
	for repo in "${PRODIGUER_REPOS[@]}"
	do
		if [ -d "$PRODIGUER_DIR_REPOS/$repo" ]; then
			run_stack_update_repo $repo
		else
			run_stack_install_repo $repo
		fi
	done
}

# Updates configuration.
run_stack_update_config()
{
	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer.json $PRODIGUER_DIR_CONFIG/prodiguer.json
	cp $PRODIGUER_DIR_TEMPLATES/config/prodiguer.sh $PRODIGUER_DIR_CONFIG/prodiguer.sh
	cp $PRODIGUER_DIR_TEMPLATES/config/mq-supervisord.conf $PRODIGUER_DIR_DAEMONS/mq/supervisord.conf
	cp $PRODIGUER_DIR_TEMPLATES/config/web-supervisord.conf $PRODIGUER_DIR_DAEMONS/web/supervisord.conf

	log "Updated configuration"
}

# Updates shell.
run_stack_update_shell()
{
	log "Updating shell"

	set_working_dir
	git pull -q
	remove_files "*.pyc"
}

# Updates source code.
run_stack_update_source()
{
	run_stack_update_shell
	run_stack_update_repos
}

# Updates stack.
run_stack_update()
{
	log "UPDATING STACK"

	run_stack_update_shell
	run_stack_update_config
	run_stack_update_repos
	run_stack_upgrade_venvs

	log "UPDATED STACK"

	_update_notice
}

# ###############################################################
# SECTION: UNINSTALL
# ###############################################################

# Uninstalls shell.
_uninstall_shell()
{
	log "Uninstalling shell"

	rm -rf $PRODIGUER_HOME
}

# Uninstalls git repo.
run_stack_uninstall_repo()
{
	log "Uninstalling repo: $1"

	rm -rf $PRODIGUER_DIR_REPOS/$1
}

# Uninstalls git repos.
_uninstall_repos()
{
	log "Uninstalling repos"

	for repo in "${PRODIGUER_REPOS[@]}"
	do
		run_stack_uninstall_repo $repo
	done
}

# Uninstalls python.
_uninstall_python()
{
	log "Uninstalling python"

	rm -rf $PRODIGUER_DIR_PYTHON
}

# Uninstalls a virtual environment.
_uninstall_venv()
{
	if [ "$2" ]; then
		log "Uninstalling virtual environment :: $1"
	fi

	rm -rf $PRODIGUER_DIR_VENV/$1
}

# Uninstalls virtual environments.
_uninstall_venvs()
{
	for venv in "${PRODIGUER_VENVS[@]}"
	do
		_uninstall_venv $venv "echo"
	done
}

# Uninstalls stack.
run_stack_uninstall()
{
	log "UNINSTALLING STACK"

	_uninstall_venvs
	_uninstall_python
	_uninstall_repos
	_uninstall_shell

	log "UNINSTALLED STACK"
}

# ###############################################################
# SECTION: CONFIGURATION
# ###############################################################

# Encrypts configuration files and saves them as template.
run_stack_config_encrypt()
{
	log "ENCRYPTING CONFIG FILES"

	# Initialise file paths.
	declare COMPRESSED=$PRODIGUER_DIR_TEMPLATES/config/$1-$2.tar
	declare ENCRYPTED=$COMPRESSED.encrypted

	# Compress.
	set_working_dir $PRODIGUER_DIR_CONFIG
	tar cvf $COMPRESSED ./*

	# Encrypt.
	openssl aes-128-cbc -salt -in $COMPRESSED -out $ENCRYPTED

	# Clean up.
	rm $COMPRESSED
	set_working_dir

	log "ENCRYPTED CONFIG FILES"
}

# Decrypts configuration files and saves them as template.
run_stack_config_decrypt()
{
	log "DECRYPTING CONFIG FILES"

	# Set paths.
	declare COMPRESSED=$PRODIGUER_DIR_TEMPLATES/config/$1-$2.tar
	declare ENCRYPTED=$COMPRESSED.encrypted

	# Decrypt files.
	openssl aes-128-cbc -d -salt -in $ENCRYPTED -out $COMPRESSED

	# Clear current configuration.
	rm -rf $PRODIGUER_DIR_CONFIG/*.*

	# Decompress files.
	tar xpvf $COMPRESSED -C $PRODIGUER_DIR_CONFIG

	# Clean up.
	rm $COMPRESSED

	log "DECRYPTED CONFIG FILES"
}

# Commits updates to configuration template files.
run_stack_config_commit()
{
	log "COMMITTING CONFIG FILES"



	log "COMMITTED CONFIG FILES"
}
