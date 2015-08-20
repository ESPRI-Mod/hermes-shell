===================================
How To Setup Operating System
===================================

**NOTE - you must be logged on as root**

Step 1: Download setup script
----------------------------

	# CentOS v6.  
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_6.sh -O ./prodiguer-os-setup.sh

	# CentOS v7.  
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_7.sh -O ./prodiguer-os-setup.sh

	# Scientific Linux v6.  
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_6.sh -O ./prodiguer-os-setup.sh

	# Scientific Linux v7.  
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_7.sh -O ./prodiguer-os-setup.sh

	# Ubuntu Mint v17.  
	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_ubuntu_mint_17.sh -O ./prodiguer-os-setup.sh

Step 2: Activate setup script
----------------------------

	chmod a+x ./prodiguer-os-setup.sh  
	source ./prodiguer-os-setup.sh

	pip install arrow
	pip install requests

Step 3: Execute setup functions
----------------------------

	# Install common libraries.
	setup_common

	# Install MongoDB server (if machine is acting as a db server).
	setup_db_mongo

	# Install PostgreSQL server (if machine is acting as a db server).
	setup_db_postgres

	# Install RabbitMQ server (if machine is acting as an mq server).
	setup_mq_rabbitmq

	# Install NGINX web server (if machine is acting as a web server).
	setup_web_nginx

**Note** - if you are setting up a machine for development purposes then you will need to execute all the setup functions listed above.