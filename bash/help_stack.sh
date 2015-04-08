help_stack_bootstrap()
{
	log "stack-bootstrap"
	log "Description: prepares system for install " 1
}

help_stack_config_commit()
{
	log "stack-config-commit"
	log "Description: commits local changes to configuration templates" 1
}

help_stack_config_decrypt()
{
	log "stack-config-decrypt MODE SERVER-TYPE"
	log "Description: decrypts & extracts configuration files" 1
	log "MODE = deployment mode [test | prod]" 1
	log "SERVER-TYPE = type of server [web | mq | db]" 1
}

help_stack_config_encrypt()
{
	log "stack-config-encrypt MODE SERVER-TYPE"
	log "Description: compresses & encrypts configuration files" 1
	log "MODE = deployment mode [test | prod]" 1
	log "SERVER-TYPE = type of server [web | mq | db]" 1
}

help_stack_install_venv()
{
	log "stack-install-venv"
	log "Description: installs a virtual environment" 1
}

help_stack_install_venvs()
{
	log "stack-install-venvs"
	log "Description: installs virtual environment" 1
}

help_stack_install_python()
{
	log "stack-install-python"
	log "Description: installs a python executable" 1
}

help_stack_install_repo()
{
	log "stack-install-repo"
	log "Description: installs a prodiguer github repo" 1
	log "NAME = name of repo to be installed" 1
}

help_stack_install_repos()
{
	log "stack-install-repos"
	log "Description: installs all prodiguer github repo" 1
}

help_stack_install()
{
	log "stack-install"
	log "Description: installs complete stack" 1
}

help_stack_update_venvs()
{
	log "stack-update-venvs"
	log "Description: updates virtual environments" 1
}

help_stack_update_repo()
{
	log "stack-update-repo"
	log "Description: updates a git repo" 1
}

help_stack_update_repos()
{
	log "stack-update-repos"
	log "Description: updates git repos" 1
}

help_stack_update_config()
{
	log "stack-update-config"
	log "Description: updates local configuration files" 1
}

help_stack_update_shell()
{
	log "stack-update-shell"
	log "Description: updates shell" 1
}

help_stack_update_source()
{
	log "stack-update-source"
	log "Description: updates shell and git repos" 1
}

help_stack_update()
{
	log "stack-update"
	log "Description: updates full stack (i.e. shell, repos, config and virtual environments)" 1
}

help_stack_uninstall()
{
	log "stack-uninstall"
	log "Description: uninstalls stack & virtual environments" 1
}

help_stack()
{
	commands=(
		bootstrap
		config_commit
		config_decrypt
		config_encrypt
		install_python
		install_repo
		install_repos
		install_venv
		install_venvs
		install
		update_config
		update_repo
		update_repos
		update_shell
		update_source
		update_venvs
		update
		uninstall
	)
	log_help_commands "stack" ${commands[@]}
}