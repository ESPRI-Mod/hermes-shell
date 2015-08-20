===================================
Prodiguer Operating System Setup
===================================

1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

2: Download setup script
----------------------------

**CentOS v6**

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_6.sh -O ./prodiguer-os-setup.sh

**CentOS v7**

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_7.sh -O ./prodiguer-os-setup.sh

**Scientific Linux v6**

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_6.sh -O ./prodiguer-os-setup.sh

**Scientific Linux v7**

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_7.sh -O ./prodiguer-os-setup.sh

**Ubuntu Mint v17**

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_ubuntu_mint_17.sh -O ./prodiguer-os-setup.sh

3: Activate setup script
----------------------------

	chmod a+x ./prodiguer-os-setup.sh
	source ./prodiguer-os-setup.sh

4: Execute required setup function
----------------------------

	setup_common

5: Execute optional setup functions
----------------------------

To install MongoDB server

	setup_db_mongo

To install PostgreSQL server

	setup_db_postgres

To install RabbitMQ server

	setup_mq_rabbitmq

To install NGINX web server

	setup_web_nginx

**Note** - if you are setting up a machine for development purposes then you will need to execute all the setup functions listed above.

6: Cleanup
----------------------------

	rm -f ./prodiguer-os-setup.sh
	exit
