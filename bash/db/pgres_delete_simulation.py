# -*- coding: utf-8 -*-

"""
.. module:: pgres_delete_simulation.py
   :copyright: Copyright "Mar 21, 2015", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Deletes simulation from HERMES postgres database tables.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import argparse

from hermes.db import pgres as db
from hermes.db.pgres import dao_monitoring as dao
from hermes.utils import logger



# Define command line arguments.
_ARGS = argparse.ArgumentParser("Deletes a simulation from database.")
_ARGS.add_argument(
    "--uid",
    help="UID of simulation to be deleted.",
    dest="uid",
    type=unicode
    )


def _main(args):
    """Main entry point.

    """
    logger.log_db("Deleting simulation: begins")

    with db.session.create(commitable=True):
        dao.delete_simulation(args.uid)

    logger.log_db("Deleting simulation: ends")


if __name__ == '__main__':
    _main(_ARGS.parse_args())
