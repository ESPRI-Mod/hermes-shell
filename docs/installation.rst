===================================
Prodiguer Shell Installation
===================================

**Note** - it is assumed that you have setup your OS correctly as documented `here <https://github.com/Prodiguer/prodiguer-shell/blob/master/docs/os-setup.rst>`_.

1: Open terminal session
----------------------------

**NOTE** - you must be logged in as root.

2: Download shell
----------------------------

Clone from remote git repository::

	cd /opt
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

5: Review installation
----------------------------

Review source code downloaded from GitHub::

	ls ./prodiguer/repos

Review operations (ops) directories::

	ls ./prodiguer/ops

Review virtual environments::

	ls ./prodiguer/ops/venv

6. Install database
----------------------------

To install prodiguer postgres database (if PostgreSQL is installed)::

	prodiguer-db-pgres-install
