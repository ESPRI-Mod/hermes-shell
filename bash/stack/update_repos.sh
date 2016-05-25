#!/bin/bash

# Import utils.
source $HERMES_HOME/bash/init.sh

# Installs a git repo.
_install_repo()
{
	log "Installing repo: $1"

	rm -rf $PRODIGUER_DIR_REPOS/$1
	git clone -q https://github.com/Prodiguer/$1.git $PRODIGUER_DIR_REPOS/$1
}

# Updates a git repo.
_update_repo()
{
	log "Updating repo: $1"

	set_working_dir $PRODIGUER_DIR_REPOS/$1
	git pull -q
	remove_files "*.pyc"
	set_working_dir
}

# Main entry point.
main()
{
	log "UPDATING REPOS"

	for repo in "${PRODIGUER_REPOS[@]}"
	do
		if [ -d "$PRODIGUER_DIR_REPOS/$repo" ]; then
			_update_repo $repo
		else
			_install_repo $repo
		fi
	done

	log "UPDATED REPOS"
}

# Invoke entry point.
main
