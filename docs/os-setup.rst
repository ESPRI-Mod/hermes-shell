===================================
HERMES Operating System Setup
===================================

1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

2: Download setup script
----------------------------

**CentOS v6**::

	wget http://bit.ly/1E7vTxV -O ./hermes-os-setup.sh

**CentOS v7**::

	wget http://bit.ly/1hOVbH7 -O ./hermes-os-setup.sh

**Scientific Linux v6**::

	wget http://bit.ly/1UVXwOH -O ./hermes-os-setup.sh

**Scientific Linux v7**::

	wget http://bit.ly/1NoHY4G -O ./hermes-os-setup.sh

**Ubuntu Mint v17**::

	wget http://bit.ly/1U1w4wu -O ./hermes-os-setup.sh

3: Activate setup script
----------------------------

Update permissions & import setup functions::

	chmod a+x ./hermes-os-setup.sh
	source ./hermes-os-setup.sh

4: Execute required setup functions
----------------------------

To install common libraries::

	hermes_setup_common

5: Execute optional setup functions
----------------------------

To install NGinx web server::

	hermes_setup_nginx

To install MongoDB server::

	hermes_setup_mongodb

To install PostgreSQL server::

	hermes_setup_postgresql

To install RabbitMQ server::

	hermes_setup_rabbitmq

**Note** - if you are setting up a machine for development purposes then you will need to execute all the setup functions listed above.

6: To verify NGinx installation
----------------------------

Start nginx service (ignore warning regarding log file location)::

	service nginx start

*	Open Firefox web browser

*	Navigate to localhost

*  The NGinx welcome page will be displayed

*  Close Firefox web browser

7: To verify MongoDB installation
----------------------------

Open a MongoDB interactive command line session::

	mongo

Type exit to close session.

8: To verify PostgreSQL installation
----------------------------

*  Click system menu option:

	-	Applications --> Programming --> pgAdmin III

*	Click pgAdmin III menu option: File --> Add Server

*	In pgAdmin III Add Server dialog enter:

	-	Name = local

	-	Host = localhost

*	Click OK button

*  	Click Ok button on next dialog that displays a "Saving passwords" warning

*	A db server called "local" now appears in list of db server connections

*	Click pgAdmin III menu option:

	-	File --> Close

9: To verify RabbitMQ installation
----------------------------

*  Open Firefox web browser

*  Enter url: **localhost:15672**

*  The RabbitMQ login page will be displayed

*  Close Firefox web browser

10: Cleanup
----------------------------

Remove setup script::

	rm -f ./hermes-os-setup.sh

Close terminal session::

	exit
