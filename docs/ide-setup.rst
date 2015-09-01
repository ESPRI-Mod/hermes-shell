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

	mkdir -p $PRODIGUER_HOME/ops/ide/sublime/locals

* Create symbolic links to prodiguer stack::

	ln -s $PRODIGUER_HOME/repos/prodiguer-client $PRODIGUER_HOME/ops/ide/sublime/locals/client
	ln -s $PRODIGUER_HOME/repos/prodiguer-cv $PRODIGUER_HOME/ops/ide/sublime/locals/cv
	ln -s $PRODIGUER_HOME/repos/prodiguer-docs $PRODIGUER_HOME/ops/ide/sublime/locals/docs
	ln -s $PRODIGUER_HOME/repos/prodiguer-fe $PRODIGUER_HOME/ops/ide/sublime/locals/fe
	ln -s $PRODIGUER_HOME/repos/prodiguer-server $PRODIGUER_HOME/ops/ide/sublime/locals/server
	ln -s $PRODIGUER_HOME $PRODIGUER_HOME/ops/ide/sublime/locals/shell

* Open sublime-text.

* Open new sublime-text project (CTL-SHIFT-N).

* From main menu click: Project -->  Save Project as ...

	+ Save project to: $PRODIGUER_HOME/ops/ide/sublime

	+ Save project as: prodiguer.sublime-project

* From main menu click: Project -->  Add Folder to Project ...

* Select folder: $PRODIGUER_HOME/ops/ide/sublime/locals

The IDE will import the symbolic links into the project folder view.  If you wish to add links to other directories within the prodiguer stack then simply repeat step 2.