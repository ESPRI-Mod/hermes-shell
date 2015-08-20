===================================
How To Setup Operating System for Prodiguer usage
===================================

**NOTE - you must be logged on as root**


Step 2: Activate setup script
----------------------------

	chmod a+x ./prodiguer-os-setup.sh
	source ./prodiguer-os-setup.sh

Step 3: Execute required setup function
----------------------------

	setup_common

Step 4: Execute optional setup functions
----------------------------

To install MongoDB server:

	setup_db_mongo

To install PostgreSQL server:

	setup_db_postgres

To install RabbitMQ server:

	setup_mq_rabbitmq

To install NGINX web server:

	setup_web_nginx

**Note** - if you are setting up a machine for development purposes then you will need to execute all the setup functions listed above.