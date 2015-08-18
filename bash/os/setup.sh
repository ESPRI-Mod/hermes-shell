source $PRODIGUER_HOME/bash/init.sh

# Parses operating system type name.
_parse_os_type()
{
	declare -a types=(
		'centos'
		'debian'
		'fedora'
		'rhel'
		'scientific-linux'
		'ubuntu'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Maps operating system type name to OS package installer.
_get_os_package_installer()
{
    if [ "$1" == "centos" ] ; then
        echo "yum"
    elif [ "$1" == "debian" ] ; then
        echo "apt"
    elif [ "$1" == "fedora" ] ; then
        echo "yum"
    elif [ "$1" == "rhel" ] ; then
        echo "yum"
    elif [ "$1" == "scientific-linux" ] ; then
        echo "yum"
    elif [ "$1" == "ubuntu" ] ; then
        echo "apt"
    fi
}

# Parses machine type name.
_parse_machine_type()
{
	declare -a types=(
		'db'
		'dev'
		'mq'
		'web'
	)
	declare result=UNKNOWN
	for i in "${types[@]}"
	do
	    if [ "$i" == "$1" ] ; then
	        result=$1
	    fi
	done
	echo $result
}

# Sets up operating system so that prodiguer stack can execute.
main()
{
	# Escape if operating system type is unsupported.
	declare os_type=$(_parse_os_type $1)
	if [ $os_type = 'UNKNOWN' ]; then
		log "Operating system ($1) is unsupported"
		exit
	fi

	# Escape if machine type is unsupported.
	declare machine_type=$(_parse_machine_type $2)
	if [ $machine_type = 'UNKNOWN' ]; then
		log "Machine type ($2) is unsupported"
		exit
	fi

	# Set package installer.
	declare package_installer=$(_get_os_package_installer $1)

	# Install common libraries setup.
	log "installing common libraries ..."
	source $PRODIGUER_DIR_BASH/os/setup_"$package_installer".sh

	# Install machine specific libraries setup.
	log "installing $machine_type libraries ..."
	source $PRODIGUER_DIR_BASH/os/setup_"$package_installer"_"$machine_type".sh
}

# Invoke entry point.
main $1 $2
