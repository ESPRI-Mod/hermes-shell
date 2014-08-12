
# Sets up the web server.
run_setup_centos_web_server()
{
	# Install common libraries.
	run_setup_centos_common

	# Install nginx.
	run_centos_web_server_install_nginx
}

# Sets up NGINX upon web server.
run_centos_web_server_install_nginx()
{
	# Install nginx.
	rpm -i $DIR_TEMPLATES/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	yum install nginx

	# Update nginx configuration.
	cp $DIR_TEMPLATES/template-nginx.conf /etc/nginx/nginx.conf
}
