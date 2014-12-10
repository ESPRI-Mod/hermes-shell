# -*- coding: utf-8 -*-

"""
.. module:: run_db_setup.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sets up prodiguer databases.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import sys

import sqlalchemy

import prodiguer
from prodiguer import db
from prodiguer.utils import config, rt



# Db user names.
_DB_USER = "prodiguer_db_user"
_DB_USER_ADMIN = "prodiguer_db_admin"


def main():
    """Main entry point."""
    def setup(connection):
        rt.log_db("SETUP BEGINS : db = {0}".format(connection))

        # Start session.
        db.session.start(connection)

        # Setup db.
        db.setup.execute()

        # End session.
        db.session.end()

        rt.log_db("SETUP ENDS : db = {0}".format(connection))
        rt.log()

    # Setup each target db.
    connection = config.db.pgres.main
    targets = [connection, connection + '_test']
    targets = [c.replace(_DB_USER, _DB_USER_ADMIN) for c in targets]

    try:
        for target in targets:
            setup(target)
    except sqlalchemy.exc.ProgrammingError as err:
        rt.log_db_error("SETUP ERROR : are db connections still open ? : db = {0}".format(target))

if __name__ == '__main__':
    main()
