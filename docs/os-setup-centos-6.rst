===================================
Prodiguer CentOS v6 Setup Guide
===================================

Setting up a machine to run Prodiguer stack is simple & straightforward.

Step 1: Install common libraries
----------------------------

The prodiguer client library requires the following python libraries all of which can be installed via pip::

	# Ensure machine is upto date.
	yum -q -y upgrade

	# Enable EPEL v6.
	rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

	# Install various tools.
	yum -q -y install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql-libs postgresql-devel python-devel postgresql-plpython python-psycopg2
