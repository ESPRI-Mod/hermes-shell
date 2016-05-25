source $HERMES_HOME/bash/init.sh

log "CV : pushing new terms to hermes-cv repo: "

set_working_dir $HERMES_DIR_REPOS/hermes-cv

git add . --force
git commit -m "hermes-cv-push--->`date +\%Y-\%m-\%dT\%H:\%M:\%S`"
git push -v origin master:master

set_working_dir

log "CV : pushed new terms to hermes-cv repo: "
