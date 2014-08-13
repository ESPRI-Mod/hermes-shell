# Module imports.
import sys

print "SSSS"

from prodiguer import db
from prodiguer.utils import (
	config,
	runtime as rt
	)



# Db user names.
_DB_USER = "prodiguer_db_user"
_DB_USER_ADMIN = "prodiguer_db_admin"


def main():
	"""Main entry point."""
	def setup(connection):
		rt.log_db("SETUP BEGINS : db = {0}".format(connection))

		# Initialize config.
		config.init("db-server", "run-db-setup")

		# Start session.
		db.session.start(connection)

		# Setup db.
		db.setup.execute()

		# Start session.
		db.session.end()

		rt.log_db("SETUP ENDS : db = {0}".format(connection))
		rt.log()

	# Setup each target db.
	for c in [config.db.connection, config.db.connection + '_test']:
		c = c.replace(_DB_USER, _DB_USER_ADMIN)
		setup(c)


if __name__ == '__main__':
    main()
