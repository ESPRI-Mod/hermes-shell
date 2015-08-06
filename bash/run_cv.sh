run_cv_git_push()
{
	log "CV : pushing new terms to prodiguer-cv repo: "

	set_working_dir $PRODIGUER_DIR_REPOS/prodiguer-cv

	git add . --force
	git commit -m "prodiguer-cv-push--->`date +\%Y-\%m-\%dT\%H:\%M:\%S`"
	git push -v origin master:master

	set_working_dir

	log "CV : pushed new terms to prodiguer-cv repo: "
}

run_cv_git_pull()
{
	run_stack_update_repo prodiguer-cv
}

run_cv_git_setup()
{
	set_working_dir $PRODIGUER_DIR_REPOS/prodiguer-cv
	git config user.name $GIT_USERNAME
	git config --list
	set_working_dir
	log "CV : configured prodiguer-cv repo for automated pushes"
}
