# Module imports.
import sys

from prodiguer import api
from prodiguer import db
from prodiguer.utils import (
	config,
	convert,
	runtime as rt
	)



# Db user names.
_DB_USER = "prodiguer_db_user"
_DB_USER_ADMIN = "prodiguer_db_admin"


def _misc():
	fp = r"/Users/macg/dev/prodiguer/repos/prodiguer-server/tests/test_files/metric_api_HISTA2_K1.csv"
	convert.csv_file_to_json_file(fp)
	convert.csv_file_to_namedtuple(fp)


def _api_run():
	"""Launches API."""
	api.run()


def _db_setup():
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


def _run_mq_agent():
	from prodiguer import mq

	# Set of mq actions mapped to action type prefix.
	_actions = {
		'c' : mq.controller.consume,
		'p' : mq.controller.produce
	}

	# Set action type prefix and target queue.
	_action_type_prefix = sys.argv[1][0]
	_queue = sys.argv[1][2:]

	# Derive action.
	_action = _actions[_action_type_prefix]

	# Apply action.
	_action(_queue)	


# Map of supported actions.
_ACTIONS = {
	"run-api": _api_run,
	"db-setup": _db_setup,
	"misc": _misc,
}


def main():
	"""Main entry point."""
	# Validate action.
	action = sys.argv[1]
	if action not in _ACTIONS:
		raise NotImplementedError(action)

	# Invoke action.
	_ACTIONS[action]()


if __name__ == '__main__':
    main()

