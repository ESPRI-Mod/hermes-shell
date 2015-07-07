# Main entry point.
main()
{
	# Ensure machine is upto date.
	yum -q upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum -q groupinstall -y development
	yum -q install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql-libs postgresql-devel python-devel postgresql-plpython python-psycopg2
}

# Invoke entry point.
main
