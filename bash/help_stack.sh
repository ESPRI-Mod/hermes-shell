help_stack_bootstrap()
{
	log "stack-bootstrap" 1
	log "prepares system for install " 2
}

help_stack_config_commit()
{
	log "stack-config-commit" 1
	log "commits local changes to configuration templates" 2
}

help_stack_config_decrypt()
{
	log "stack-config-decrypt" 1
	log "decrypts & extracts configuration files" 2
	log "MODE = deployment mode [test | prod]" 2
	log "SERVER-TYPE = type of server [web | mq | db]" 2
}

help_stack_config_encrypt()
{
	log "stack-config-encrypt" 1
	log "compresses & encrypts configuration files" 2
	log "MODE = deployment mode [test | prod]" 2
	log "SERVER-TYPE = type of server [web | mq | db]" 2
}

help_stack_install_venv()
{
	log "stack-install-venv" 1
	log "installs a virtual environment" 2
}

help_stack_install_venvs()
{
	log "stack-install-venvs" 1
	log "installs virtual environment" 2
}

help_stack_install_python()
{
	log "stack-install-python" 1
	log "installs a python executable" 2
}

help_stack_install_repo()
{
	log "stack-install-repo" 1
	log "installs a prodiguer github repo" 2
	log "NAME = name of repo to be installed" 2
}

help_stack_install_repos()
{
	log "stack-install-repos" 1
	log "installs all prodiguer github repo" 2
}

help_stack_install()
{
	log "stack-install" 1
	log "installs complete stack" 2
}

help_stack_update_venvs()
{
	log "stack-update-venvs" 1
	log "updates virtual environments" 2
}

help_stack_update_repo()
{
	log "stack-update-repo" 1
	log "updates a git repo" 2
}

help_stack_update_repos()
{
	log "stack-update-repos" 1
	log "updates git repos" 2
}

help_stack_update_config()
{
	log "stack-update-config" 1
	log "updates local configuration files" 2
}

help_stack_update_shell()
{
	log "stack-update-shell" 1
	log "updates shell" 2
}

help_stack_update_source()
{
	log "stack-update-source" 1
	log "updates shell and git repos" 2
}

help_stack_update()
{
	log "stack-update" 1
	log "updates full stack (i.e. shell, repos, config and virtual environments)" 2
}

help_stack_uninstall()
{
	log "stack-uninstall" 1
	log "uninstalls stack & virtual environments" 2
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