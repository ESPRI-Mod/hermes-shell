#!/bin/bash

# ###############################################################
# SECTION: BOOTSTRAP
# ###############################################################

run_stack_init_ops_directories()
{
	log "Initializing ops directories"
	set_working_dir
	for ops_dir in "${OPS_DIRS[@]}"
	do
		mkdir -p $ops_dir
	done
}

# Run stack bootstrapper.
run_stack_bootstrap()
{
	log "BOOTSTRAP STARTS"
	set_working_dir

	run_stack_init_ops_directories

	log "Initializing configuration"
	cp $DIR_TEMPLATES/config/prodiguer.sh $DIR_CONFIG/prodiguer.sh
	cp $DIR_TEMPLATES/config/prodiguer.json $DIR_CONFIG/prodiguer.json
	cp $DIR_TEMPLATES/config/mq-supervisord.conf $DIR_CONFIG/mq-supervisord.conf

	log "BOOTSTRAP ENDS"

	log
	log "IMPORTANT NOTICE"
	log "The bootstrap process installs the following config files:" 1
	log "$DIR_CONFIG/prodiguer.json" 2
	log "$DIR_CONFIG/prodiguer.sh" 2
	log "Please review and assign settings as appropriate to your " 1
	log "environemt prior to continuing with the installation process." 1
	log "Also ensure that the relevant Prodiguer environemt variables are initialized." 1

	log "IMPORTANT NOTICE ENDS"
}

# ###############################################################
# SECTION: INSTALL
# ###############################################################

# Display post install notice.
_install_notice()
{
	log
	log "IMPORTANT NOTICE"
	log "To prodiguer shell command aliases add the following line to your .bash_profile file:" 1
	log "test -f $DIR/exec.aliases && source $DIR/exec.aliases" 2
	log "IMPORTANT NOTICE ENDS"
}


# Installs virtual environments.
run_stack_install_venv()
{
	if [ "$2" ]; then
		log "Installing virtual environment: $1"
	fi

	# Make directory.
	declare TARGET_VENV=$DIR_VENV/$1
	rm -rf $TARGET_VENV
    mkdir -p $TARGET_VENV

    # Initialise venv.
    export PATH=$DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$DIR_PYTHON
    virtualenv -q $TARGET_VENV

    # Build dependencies.
    source $TARGET_VENV/bin/activate
	declare TARGET_REQUIREMENTS=$DIR_TEMPLATES/venv/requirements-$1.txt
    pip install -q --allow-all-external -r $TARGET_REQUIREMENTS

    # Cleanup.
    deactivate
}

# Installs python virtual environments.
run_stack_install_venvs()
{
	for venv in "${VENVS[@]}"
	do
		run_stack_install_venv $venv "echo"
	done
}

# Installs a python executable primed with setuptools, pip & virtualenv.
run_stack_install_python()
{
	log "Installing python "$PYTHON_VERSION" (takes approx 2 minutes)"

	# Download source.
	set_working_dir $DIR_PYTHON
	mkdir src
	cd src
	wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz --no-check-certificate
	tar -xvf Python-$PYTHON_VERSION.tgz
	rm Python-$PYTHON_VERSION.tgz

	# Compile.
	cd Python-$PYTHON_VERSION
	./configure --prefix=$DIR_PYTHON
	make
	make install
	export PATH=$DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$DIR_PYTHON

	# Install setuptools.
	cd $DIR_PYTHON/src
	wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py
	python ez_setup.py

	# Install pip.
	easy_install --prefix $DIR_PYTHON pip

	# Install virtualenv.
	pip install virtualenv
}

# Installs a git repo.
run_stack_install_repo()
{
	log "Installing repo: $1"

	rm -rf $DIR_REPOS/$1
	git clone -q https://github.com/Prodiguer/$1.git $DIR_REPOS/$1
}

# Installs git repos.
run_stack_install_repos()
{
	for repo in "${REPOS[@]}"
	do
		run_install_repo $repo
	done
}

# Sets up directories.
_install_dirs()
{
	mkdir -p $DIR_REPOS
	mkdir -p $DIR_PYTHON
	mkdir -p $DIR_TMP
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
	log "$DIR_CONFIG/prodiguer-backup.json" 2
	log "$DIR_CONFIG/prodiguer-backup.sh" 2
	log "If the config schema version of the new and existing config files is different then you will need to update your local settings accordingly." 1
	log "IMPORTANT NOTICE ENDS"
}

# Upgrades a virtual environment.
run_stack_upgrade_venv()
{
	log "Upgrading virtual environment :: $1"

	declare TARGET_VENV=$DIR_VENV/$1
	declare TARGET_VENV_REQUIREMENTS=$DIR_TEMPLATES/venv/requirements-$1.txt
    source $TARGET_VENV/bin/activate
    pip install -q --allow-all-external --upgrade -r $TARGET_VENV_REQUIREMENTS
}

# Upgrades virtual environments.
run_stack_upgrade_venvs()
{
	export PATH=$DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$DIR_PYTHON
	for venv in "${VENVS[@]}"
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
	export PATH=$DIR_PYTHON/bin:$PATH
	export PYTHONPATH=$PYTHONPATH:$DIR_PYTHON
	for venv in "${VENVS[@]}"
	do
		run_stack_update_venv $venv
	done
}

# Updates a git repo.
run_stack_update_repo()
{
	log "Updating repo: $1"

	set_working_dir $DIR_REPOS/$1
	git pull -q
	remove_files "*.pyc"
	set_working_dir
}

# Updates git repos.
run_stack_update_repos()
{
	for repo in "${REPOS[@]}"
	do
		if [ -d "$DIR_REPOS/$repo" ]; then
			run_stack_update_repo $repo
		else
			run_stack_install_repo $repo
		fi
	done
	for repo in "${REPOS_OBSOLETE[@]}"
	do
		if [ -d "$DIR_REPOS/$repo" ]; then
			run_stack_uninstall_repo $repo
		fi
	done
}

# Updates configuration.
run_stack_update_config()
{
	# # Create backups.
	# cp $DIR_CONFIG/prodiguer.json $DIR_CONFIG/prodiguer-backup.json
	# cp $DIR_CONFIG/config/prodiguer.sh $DIR_CONFIG/prodiguer-backup.sh
	# cp $DIR_CONFIG/config/mq-supervisord.conf $DIR_CONFIG/mq-supervisord-backup.conf
	# cp $DIR_CONFIG/config/web-supervisord.conf $DIR_CONFIG/web-supervisord-backup.conf

	cp $DIR_TEMPLATES/config/prodiguer.json $DIR_CONFIG/prodiguer.json
	cp $DIR_TEMPLATES/config/prodiguer.sh $DIR_CONFIG/prodiguer.sh
	cp $DIR_TEMPLATES/config/mq-supervisord.conf $DIR_CONFIG/mq-supervisord.conf
	cp $DIR_TEMPLATES/config/web-supervisord.conf $DIR_CONFIG/web-supervisord.conf

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
	run_stack_update_venvs

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

	rm -rf $DIR
}

# Uninstalls git repo.
run_stack_uninstall_repo()
{
	log "Uninstalling repo: $1"

	rm -rf $DIR_REPOS/$1
}

# Uninstalls git repos.
_uninstall_repos()
{
	log "Uninstalling repos"

	for repo in "${REPOS[@]}"
	do
		run_stack_uninstall_repo $repo
	done
}

# Uninstalls python.
_uninstall_python()
{
	log "Uninstalling python"

	rm -rf $DIR_PYTHON
}

# Uninstalls a virtual environment.
_uninstall_venv()
{
	if [ "$2" ]; then
		log "Uninstalling virtual environment :: $1"
	fi

	rm -rf $DIR_VENV/$1
}

# Uninstalls virtual environments.
_uninstall_venvs()
{
	for venv in "${VENVS[@]}"
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
	declare COMPRESSED=$DIR_TEMPLATES/config/$1-$2.tar
	declare ENCRYPTED=$COMPRESSED.encrypted

	# Compress.
	set_working_dir $DIR_CONFIG
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
	declare COMPRESSED=$DIR_TEMPLATES/config/$1-$2.tar
	declare ENCRYPTED=$COMPRESSED.encrypted

	# Decrypt files.
	openssl aes-128-cbc -d -salt -in $ENCRYPTED -out $COMPRESSED

	# Clear current configuration.
	rm -rf $DIR_CONFIG/*.*

	# Decompress files.
	tar xpvf $COMPRESSED -C $DIR_CONFIG

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
