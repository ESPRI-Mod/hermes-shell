#!/bin/bash

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
# SECTION: CONFIGURATION
# ###############################################################



