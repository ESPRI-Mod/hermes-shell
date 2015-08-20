===================================
Prodiguer Operating System Setup
===================================

1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

2: Download setup script
----------------------------

**CentOS v6**::

	wget http://bit.ly/1E7vTxV -O ./prodiguer-os-setup.sh

**CentOS v7**::

	wget http://bit.ly/1hOVbH7 -O ./prodiguer-os-setup.sh

**Scientific Linux v6**::

	wget http://bit.ly/1UVXwOH -O ./prodiguer-os-setup.sh

**Scientific Linux v7**::

	wget http://bit.ly/1NoHY4G -O ./prodiguer-os-setup.sh

**Ubuntu Mint v17**::

	wget http://bit.ly/1U1w4wu -O ./prodiguer-os-setup.sh

3: Activate setup script
----------------------------

Update permissions & import setup functions::

	chmod a+x ./prodiguer-os-setup.sh
	source ./prodiguer-os-setup.sh

4: Execute required setup functions
----------------------------

To install common libraries::

	setup_common

5: Execute optional setup functions
----------------------------

To install MongoDB server::

	setup_db_mongo

To install PostgreSQL server::

	setup_db_postgres

To install RabbitMQ server::

	setup_mq_rabbitmq

To install NGINX web server::

	setup_web_nginx

**Note** - if you are setting up a machine for development purposes then you will need to execute all the setup functions listed above.

6: Cleanup
----------------------------

Remove setup script & close terminal session::

	rm -f ./prodiguer-os-setup.sh
	exit
