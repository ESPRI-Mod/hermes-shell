# -*- coding: utf-8 -*-

"""
.. module:: run_db_setup.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sets up prodiguer databases.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import db
from prodiguer.utils import config, rt




_UID = "e18b6143-ec32-420d-a313-fedc8cae78b3"


def main():
    """Main entry point.

    """
    # Start session.
    db.session.start(config.db.pgres.main)

    print db.dao.get_simulation_state(_UID)


    # End session.
    db.session.end()



if __name__ == '__main__':
    main()
