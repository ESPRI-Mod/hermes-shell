============================
Prodiguer Shell Usage Guide - Message Queue Commands
============================

Upon successful `installation <https://github.com/Prodiguer/prodiguer-client/blob/master/docs/installation.rst>`_ of the `prodiguer client <https://github.com/Prodiguer/prodiguer-client>`_ library, supported commands can easily be called from command line.  Listed below are the full set of supported commands alongside command argument descriptions.

**Note** - For each command listed below type -h or --help to access the command's help text.

prodiguer-mq
----------------------------

Uploads simulation metrics to remote repository.

**-f, --file**

	Path to a metrics file to be uploaded to server

**--duplicate-action**

	Action to take when adding a metric with a duplicate hash identifier.  **Default = skip**.

	**skip** = duplicate metrics are ignored.

	**force** = existing metrics are overwritten.
