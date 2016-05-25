source $HERMES_HOME/bash/init.sh

log "CV : pushing new terms to prodiguer-cv repo: "

set_working_dir $HERMES_DIR_REPOS/prodiguer-cv

git add . --force
git commit -m "prodiguer-cv-push--->`date +\%Y-\%m-\%dT\%H:\%M:\%S`"
git push -v origin master:master

set_working_dir

log "CV : pushed new terms to prodiguer-cv repo: "
