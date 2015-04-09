# Sets up libraries used on all centos servers.
setup_common()
{
	# Ensure machine is upto date.
	yum upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum groupinstall -y development
	yum install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql93-libs postgresql-devel postgresql93-devel python-devel postgresql93-plpython python-psycopg2
}

# Sets up NGINX upon web server.
setup_nginx()
{
	# Install nginx.
	rpm -i $DIR_TEMPLATES/other/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum install nginx

	# Update nginx configuration.
	cp $DIR_TEMPLATES/config/nginx.conf /etc/nginx/nginx.conf
}

# Main entry point.
main()
{
	# Download prodiguer shell.
	yum install git
	cd /opt
	git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

	# Set vars.
	declare DIR_TEMPLATES=./prodiguer/templates

	# Install common libraries.
	setup_common

	# Install nginx server.
	setup_nginx

	# Install stack.
	./prodiguer/exec.sh stack-bootstrap
	./prodiguer/exec.sh stack-install
}

# Invoke entry point.
main