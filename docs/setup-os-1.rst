===================================
Prodiguer Operating System Setup
===================================

Step 1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

Step 2: Download setup script
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

::	chmod a+x ./prodiguer-os-setup.sh
	source ./prodiguer-os-setup.sh

4: Execute required setup function
----------------------------

	setup_common
