source $HERMES_HOME/bash/init.sh

log "CV : pushing new terms to hermes-cv repo: "

set_working_dir $HERMES_DIR_REPOS/hermes-cv

export http_proxy=http://proxy.ipsl.jussieu.fr:3128/ && export https_proxy=https://proxy.ipsl.jussieu.fr:3128/
git add . --force
git commit -m "hermes-cv-push--->`date +\%Y-\%m-\%dT\%H:\%M:\%S`"
git push -v origin master:master

set_working_dir

log "CV : pushed new terms to hermes-cv repo: "
