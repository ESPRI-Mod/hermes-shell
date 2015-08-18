# Main entry point.
main()
{
	source $PRODIGUER_DIR_BASH/os/setup_yum_db.sh
	source $PRODIGUER_DIR_BASH/os/setup_yum_mq.sh
	source $PRODIGUER_DIR_BASH/os/setup_yum_web.sh
}

# Invoke entry point.
main
