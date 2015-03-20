help_cv_git_push()
{
	log "cv-git-push" 1
	log "pushes new cv terms to prodiguer-cv GitHub repo" 2
}

help_cv_git_pull()
{
	log "cv-git-pull" 1
	log "pulls new cv terms from prodiguer-cv GitHub repo" 2
}

help_cv_git_setup()
{
	log "cv-git-setup" 1
	log "initializes environment for prodiguer-cv GitHub actions" 2
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
