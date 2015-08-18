# Main entry point.
main()
{
	source $PRODIGUER_DIR_BASH/os/setup_apt_db.sh
	source $PRODIGUER_DIR_BASH/os/setup_apt_mq.sh
	source $PRODIGUER_DIR_BASH/os/setup_apt_web.sh
}

# Invoke entry point.
main
