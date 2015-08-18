# Main entry point.
main()
{
	source $PRODIGUER_DIR_BASH/run_os_setup_centos_db.sh
	source $PRODIGUER_DIR_BASH/run_os_setup_centos_mq.sh
	source $PRODIGUER_DIR_BASH/run_os_setup_centos_web.sh
}

# Invoke entry point.
main
