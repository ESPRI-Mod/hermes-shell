#!/bin/bash

# ###############################################################
# SECTION: OS COMMANDS
# ###############################################################

# Sets up libraries used on all centos servers.
run_setup_centos_common()
{
	# Ensure machine is upto date.
	yum upgrade

	# Install various tools.
	yum groupinstall -y development
	yum install xz-libs zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel postgresql93-libs postgresql-devel postgresql93-devel python-devel postgresql93-plpython python-psycopg2
}
