===================================
Prodiguer Shell - Installation
===================================

**Note** - it is assumed that your OS is setup correctly as documented `here <https://github.com/Prodiguer/prodiguer-shell/blob/master/docs/os-setup.rst>`_.

1: Open terminal session
----------------------------

Log in under the user account that will be used to to run / develop the shell.

**Note** - it is not advised to login as root.

2: Download shell
----------------------------

Clone from remote git repository::

	cd $HOME
	git clone https://github.com/Prodiguer/prodiguer-shell.git prodiguer

3: Define environment variables
----------------------------

Copy template::

	cp ./prodiguer/templates/prodiguer_env.sh $HOME/.prodiguer_server

Review & edit defaults::

	vi $HOME/.prodiguer_server

4: Run stack installer
----------------------------

Activate shell::

	source ./prodiguer/activate

Run installer (takes 10-15 minutes)::

	prodiguer-stack-install

5. Install database
----------------------------

To install prodiguer postgres database (if PostgreSQL is installed)::

	prodiguer-db-pgres-install


6.	Verification
----------------------------

Verify that the prodiguer web service can be started::

	prodiguer-web-service

Then perform the following:

*  Open Firefox web browser

*  Enter url: **localhost:8888/api**

*  The prodiguer web service is running message will be displayed

*  Enter url: **localhost:8888/static/simulation.monitoring.html**

*  The prodiguer simulation moinitoring web application will be displayed

*  Close Firefox web browser

*	CTL-C to stop prodiguer web service
