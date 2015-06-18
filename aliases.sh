# Create root alias.
alias prodiguer="$( dirname "${BASH_SOURCE[0]}" )"/exec.sh

# Supported command types.
declare -a command_types=(
	cv
	db
	mq
	os
	stack
	utests
	web
)

# Supported commands.
declare -a commands=(
	# Controlled vocabulary admin.
	cv-git-pull
	cv-git-push
	cv-git-setup
	# DB admin.
	db-pgres-backup
	db-pgres-install
	db-pgres-migrate
	db-pgres-reset
	db-pgres-cv-table-reset
	db-pgres-restore
	db-pgres-uninstall
	# MQ admin.
	mq-configure
	mq-consume
	mq-daemons-init
	mq-daemons-kill
	mq-daemons-refresh
	mq-daemons-restart
	mq-daemons-start
	mq-daemons-status
	mq-daemons-stop
	mq-produce
	mq-purge
	# Server setup.
	os-setup
	# Stack management.
	stack-bootstrap
	stack-install
	stack-update
	stack-update-shell
	stack-update-repo
	stack-update-repos
	stack-update-venv
	stack-update-venvs
	stack-update-source
	stack-uninstall
	stack-uninstall-repo
	stack-config-commit
	stack-config-encrypt
	stack-config-decrypt
	# Web service.
	web-api
	web-daemons-init
	web-daemons-kill
	web-daemons-refresh
	web-daemons-restart
	web-daemons-start
	web-daemons-status
	web-daemons-stop
)

# Set path to exec.sh.
PRODIGUER_SHELL_EXEC="$( dirname "${BASH_SOURCE[0]}" )"/exec.sh

# Create default alias.
alias prodiguer=$PRODIGUER_SHELL_EXEC

# Create command aliases.
for command in "${commands[@]}"
do
	alias prodiguer-$command=$PRODIGUER_SHELL_EXEC" "$command
done

# Create command type help aliases.
for command_type in "${command_types[@]}"
do
	alias help-prodiguer-$command_type=$PRODIGUER_SHELL_EXEC" help-"$command_type
done

# Create command help aliases.
for command in "${commands[@]}"
do
	alias help-prodiguer-$command=$PRODIGUER_SHELL_EXEC" help-"$command
done

# Composite commands.
alias prodiguer-db-reset='prodiguer-cv-git-pull && prodiguer-db-pgres-reset'

# Unset vars so they do not leak into terminal session.
unset PRODIGUER_SHELL_EXEC
unset command_type
unset command_types
unset command
unset commands
