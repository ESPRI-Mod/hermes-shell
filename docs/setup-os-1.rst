===================================
Prodiguer Operating System Setup
===================================

Installing the prodiguer client library is simple & straightforward.

**Note** - it is assumed that git and pip are available.

Step 1: Install python dependencies
----------------------------

The prodiguer client library requires the following python libraries all of which can be installed via pip::

	pip install arrow
	pip install requests

Step 2: Clone from GitHub
----------------------------

Simply clone from GitHub into your working directory::

	cd YOUR_WORKING_DIRECTORY
	git clone https://github.com/Prodiguer/prodiguer-client.git

Step 3: Setup shell environment
----------------------------

Edit either $HOME/.bash_profile or $HOME/.bash_rc to setup your shell environment so that the prodiguer client library is correctly initialised.  You may cut & paste the following code (remember to define the YOUR_WORKING_DIRECTORY field)::

	# --------------------------------------------------------------------
	# Prodiguer client settings
	# --------------------------------------------------------------------

	# Prodiguer: client path
	export PRODIGUER_CLIENT_HOME=YOUR_WORKING_DIRECTORY/prodiguer-client

	# Prodiguer: web-service URL.
	export PRODIGUER_CLIENT_WEB_URL='https://prodiguer-test-web.ipsl.fr'

	# Prodiguer: client aliases
	source $PRODIGUER_CLIENT_HOME/aliases.sh

	# Prodiguer: client python path
	export PYTHONPATH=$PYTHONPATH:$PRODIGUER_CLIENT_HOME

Step 4.	Command line usage
----------------------------

Open a new interactive terminal session in order to activate the prodiguer client commands.  Full usage instructions are documented `here <https://github.com/Prodiguer/prodiguer-client/blob/master/docs/usage.rst>`_.