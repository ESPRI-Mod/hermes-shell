===================================
HERMES Shell - Installation
===================================

**Note** - it is assumed that your OS is setup correctly as documented `here <https://github.com/Prodiguer/hermes-shell/blob/master/docs/os-setup.rst>`_.

1: Open terminal session
----------------------------

Log in under the user account that will be used to to run / develop the shell.

**Note** - it is not advised to login as root.

2: Download shell
----------------------------

Clone from remote git repository::

	cd $HOME/opt
	git clone https://github.com/Prodiguer/hermes-shell.git hermes

3: Define environment variables
----------------------------

Copy template::

	cp ./hermes/templates/hermes_env.sh $HOME/.hermes

Review & edit defaults::

	vi $HOME/.hermes

4: Run stack installer
----------------------------

Activate shell::

	source ./hermes/activate

Run installer (takes 10-15 minutes)::

	hermes-stack-install

5. Install database
----------------------------

To install HERMES postgres database (if PostgreSQL is installed)::

	hermes-db-pgres-install

6.	Verification
----------------------------

Verify that the HERMES web service can be started::

	hermes-web-service

Then perform the following:

*  Open Firefox web browser

*  Enter url: **localhost:8888/api**

*  The HERMES web service is running message will be displayed

*  Enter url: **localhost:8888/static/simulation.monitoring.html**

*  The HERMES simulation moinitoring web application will be displayed

*  Close Firefox web browser

*  CTL-C to stop HERMES web service
