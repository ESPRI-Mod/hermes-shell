help_cv_git_push()
{
	log "cv-git-push"
	log "Description: pushes new cv terms to prodiguer-cv GitHub repo" 1
}

help_cv_git_pull()
{
	log "cv-git-pull"
	log "Description: pulls new cv terms from prodiguer-cv GitHub repo" 1
}

help_cv_git_setup()
{
	log "cv-git-setup"
	log "Description: initializes environment for prodiguer-cv GitHub actions" 1
}

help_cv()
{
	commands=(
		git_setup
		git_pull
		git_push
	)
	log_help_commands "cv" ${commands[@]}
}
