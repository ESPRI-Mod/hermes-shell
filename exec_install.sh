#!/bin/bash

# ###############################################################
# SECTION: BOOTSTRAP
# ###############################################################

# Intiializes configuration files.
_boostrap_init_config()
{
	log "Initializing configuration"

	cp $DIR_TEMPLATES/template-config.json $DIR/config.json
}

# Displays information notice upon installation.
_bootstrap_notice()
{
	log_banner
	log "IMPORTANT NOTICE"
	log "The bootstrap process installs a config file:" 1
	log "./prodiguer/config.json" 2
	log "Please review and assign settings as appropriate to your " 1
	log "environemt prior to continuing with the installation process." 1
	log "IMPORTANT NOTICE ENDS"
}

bootstrap()
{
	log "BOOTSTRAP STARTS"
	set_working_dir 
	_boostrap_init_config
	log "BOOTSTRAP ENDS"
	_bootstrap_notice
}


# ###############################################################
# SECTION: INSTALL
# ###############################################################

# Installs virtual environments.
_install_venv()
{
	if [ "$2" ]; then
		log "Installing virtual environment: $1"
	fi

	TARGET_VENV=$DIR_VENV/$1	
	TARGET_REQUIREMENTS=$DIR_TEMPLATES/template-venv-$1.txt
	rm -rf $TARGET_VENV
    mkdir -p $TARGET_VENV
    virtualenv -q $TARGET_VENV
    source $TARGET_VENV/bin/activate
    pip install -q --allow-all-external -r $TARGET_REQUIREMENTS 
    deactivate
}

# Installs python virtual environments.
_install_venvs()
{
	_install_venv "server" "echo"
}

# Installs a python executable primed with setuptools, pip & virtualenv.
_install_python()
{
	log "Installing python "$PYTHON_VERSION" (takes approx 2 minutes)"

	# Download source.
	set_working_dir $DIR_PYTHON
	mkdir src	
	cd src
	wget http://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz 
	tar -xvf Python-$PYTHON_VERSION.tgz 
	rm Python-$PYTHON_VERSION.tgz

	# Compile.
	cd Python-$PYTHON_VERSION
	./configure --prefix=$DIR_PYTHON 
	make 
	make install 
	export PATH=$DIR_PYTHON/bin:$PATH

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
_install_repo()
{
	log "Installing repo: $1"

	rm -rf $DIR_REPOS/$1
	git clone -q https://github.com/momipsl/$1.git $DIR_REPOS/$1
}

# Installs git repos.
_install_repos()
{
	_install_repo prodiguer-fe
	_install_repo prodiguer-server
}

# Sets up directories.
_install_dirs()
{
	mkdir -p $DIR_REPOS
	mkdir -p $DIR_DB/backups
	mkdir -p $DIR_PYTHON
	mkdir -p $DIR_TMP
}

# Installs stack.
install()
{
	log "INSTALLING STACK"

	_install_dirs
	_install_repos
	_install_python
	_install_venvs

	log "INSTALLED STACK"
}


# ###############################################################
# SECTION: UPDATE
# ###############################################################

# Displays information notice upon update.
_update_notice()
{
	log_banner
	log "IMPORTANT NOTICE"
	log "The update process created a new config file:" 1
	log "./prodiguer/config.json" 2
	log "It also created a backup of your old config file:" 1
	log "./prodiguer/config.json-backup" 2
	log "Please verify your local configuration settings accordingly." 1
	log "IMPORTANT NOTICE ENDS"
}

_update_venv()
{
	log "Updating virtual environment :: $1"

	_uninstall_venv $1
	_install_venv $1
}

# updates virtual environments.
_update_venvs()
{
	export PATH=$DIR_PYTHON/bin:$PATH
	_update_venv "server"
}

# Updates a repo.
_update_repo()
{
	log "Updating repo: $1"

	set_working_dir $DIR_REPOS/$1
	git pull -q 
	set_working_dir
}

# Updates repos.
_update_repos()
{
	_update_repo prodiguer-fe
	_update_repo prodiguer-server
}

# Updates config file.
_update_config()
{
	log "Updating configuration"

	cp ./config.json ./config.json-backup	
	cp $DIR_TEMPLATES/template-config.json $DIR/config.json
}

# Updates shell.
_update_shell()
{
	log "Updating shell"

	set_working_dir		
	git pull -q 
}

# Updates stack.
update()
{
	log "UPDATING STACK"

	_update_shell
	_update_config
	_update_repos
	_update_venvs	

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
_uninstall_repo()
{
	rm -rf $DIR_REPOS/$1
}

# Uninstalls git repos.
_uninstall_repos()
{
	log "Uninstalling repos"

	_uninstall_repo prodiguer-fe
	_uninstall_repo prodiguer-server
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
	_uninstall_venv "server" "echo"
}

# Uninstalls stack.
uninstall()
{
	log "UNINSTALLING STACK"

	_uninstall_venvs
	_uninstall_python
	_uninstall_repos
	_uninstall_shell

	log "UNINSTALLED STACK"
}