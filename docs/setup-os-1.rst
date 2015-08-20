===================================
Prodiguer Operating System Setup
===================================

Step 1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

Step 2: Download setup script
----------------------------

**CentOS v6**::

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_6.sh -O ./prodiguer-os-setup.sh

**CentOS v7**::

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_centos_7.sh -O ./prodiguer-os-setup.sh

**Scientific Linux v6**::

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_6.sh -O ./prodiguer-os-setup.sh

**Scientific Linux v7**::

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_scientific_linux_7.sh -O ./prodiguer-os-setup.sh

**Ubuntu Mint v17**::

	wget https://raw.githubusercontent.com/Prodiguer/prodiguer-shell/master/bash/os/setup_ubuntu_mint_17.sh -O ./prodiguer-os-setup.sh

3: Activate setup script
----------------------------

.. ::
	chmod a+x ./prodiguer-os-setup.sh
	source ./prodiguer-os-setup.sh

4: Execute required setup function
----------------------------

	setup_common
