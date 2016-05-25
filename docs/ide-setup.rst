===================================
Prodiguer Shell - IDE Setup
===================================

Once the prodiguer-shell has been `installed <https://github.com/Prodiguer/prodiguer-shell/blob/master/docs/installation.rst>`_ and `configured <https://github.com/Prodiguer/prodiguer-shell/blob/master/docs/configuration.rst>`_ then you may wish to setup your Integrated Development Environment (IDE) so that you can begin contributing.

This guide streamlines preparing an IDE for Prodiguer platform development.  The supported IDE types are:

* `sublime-text <http://www.sublimetext.com>`_

Assumptions
----------------------------

- You have `installed <https://github.com/Prodiguer/prodiguer-shell/blob/master/docs/installation.rst>`_ the prodiguer stack.

- You have setup sublime text for `python development <https://realpython.com/blog/python/setting-up-sublime-text-3-for-full-stack-python-development>`_.

Setting up sublime-text
----------------------------

* Create sublime-text directories::

	mkdir -p $HERMES_HOME/ops/ide/sublime/locals

* Create symbolic links to prodiguer stack::

	ln -s $HERMES_HOME/repos/prodiguer-client $HERMES_HOME/ops/ide/sublime/locals/client
	ln -s $HERMES_HOME/repos/prodiguer-cv $HERMES_HOME/ops/ide/sublime/locals/cv
	ln -s $HERMES_HOME/repos/prodiguer-docs $HERMES_HOME/ops/ide/sublime/locals/docs
	ln -s $HERMES_HOME/repos/prodiguer-fe $HERMES_HOME/ops/ide/sublime/locals/fe
	ln -s $HERMES_HOME/repos/prodiguer-server $HERMES_HOME/ops/ide/sublime/locals/server
	ln -s $HERMES_HOME $HERMES_HOME/ops/ide/sublime/locals/shell

* Open sublime-text.

* Open new sublime-text project (CTL-SHIFT-N).

* From main menu click: Project -->  Save Project as ...

	Save project as: $HERMES_HOME/ops/ide/sublime/prodiguer.sublime-project

* From main menu click: Project -->  Add Folder to Project ...

* Select folder: $HERMES_HOME/ops/ide/sublime/locals

The IDE will import the symbolic links into the project folder view.  If you wish to add links to other directories within the prodiguer stack then simply repeat step 2.