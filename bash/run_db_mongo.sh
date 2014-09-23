run_db_mongo_start()
{
	sudo service mongod start
}

run_db_mongo_stop()
{
	sudo service mongod stop
}

run_db_mongo_restart()
{
	sudo service mongod restart
}

run_db_mongo_install()
{
	# Configure the package management system (YUM).
	cp $DIR_RESOURCES/other/yum-repo-mongodb.repo /etc/yum.repos.d/mongodb.repo

	# Install latest stable version of mongodb.
	yum install -y mongodb-org
}
