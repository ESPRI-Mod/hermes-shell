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
	db-pgres-reset-cv-table
	db-pgres-reset-email-table
	db-pgres-reset-message-table
	db-pgres-restore
	db-pgres-uninstall
	# MQ admin.
	mq-configure
	mq-consume
	mq-daemons-init
	mq-daemons-kill
	mq-daemons-refresh
	mq-daemons-reset-logs
	mq-daemons-restart
	mq-daemons-start
	mq-daemons-status
	mq-daemons-stop
	mq-daemons-update-config
	mq-daemons-update-config-for-debug
	mq-produce
	mq-purge
	mq-purge-debug-queues
	# Server setup.
	os-setup
	# Stack management.
	stack-bootstrap
	stack-bootstrap-environment-variables
	stack-install
	stack-update
	stack-update-aliases
	stack-update-config
	stack-update-shell
	stack-update-repo
	stack-update-repos
	stack-update-venv
	stack-update-venvs
	stack-update-source
	stack-upgrade-venvs
	stack-uninstall
	stack-uninstall-repo
	stack-config-commit
	stack-config-encrypt
	stack-config-decrypt
	# Tests.
	tests
	# Web service.
	web-api
	web-daemons-init
	web-daemons-kill
	web-daemons-refresh
	web-daemons-reset-logs
	web-daemons-restart
	web-daemons-start
	web-daemons-status
	web-daemons-stop
	web-daemons-update-config
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
