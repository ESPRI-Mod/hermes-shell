# Sets up NGINX upon web server.
_setup_nginx()
{
	# Install nginx.
	rpm -i $DIR_TEMPLATES/other/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum -q -y install nginx

	# Update nginx configuration.
	cp $DIR_TEMPLATES/config/web-nginx.conf /etc/nginx/nginx.conf
}

# Main entry point.
main()
{
	# Install nginx server.
	_setup_nginx
}

# Invoke entry point.
main