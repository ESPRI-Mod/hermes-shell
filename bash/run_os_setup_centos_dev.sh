# Main entry point.
main()
{
	source $DIR_BASH/run_os_setup_centos_db.sh
	source $DIR_BASH/run_os_setup_centos_mq.sh
	source $DIR_BASH/run_os_setup_centos_web.sh
}

# Invoke entry point.
main