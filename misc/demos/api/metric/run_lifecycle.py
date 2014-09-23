# -*- coding: utf-8 -*-

# Module imports.
import csv
import os
import sys

import requests

from demos.metric import utils as u
from prodiguer.utils import convert



def _add():
	"""Add a metric group."""
	# Set group.
	group = u.get_valid_metrics()

	# Invoke api.
	r = u.invoke_api(requests.post, u.EP_ADD, group)
	r = r.json()

	u.log("add", r)


def _add_from_csv(fp=None):
	"""Add a metric group from a csv file."""
	# Parse csv filepath.
	if fp is None:
		fp = u.METRICS_CSV
	if not os.path.exists(fp):
		raise IOError("Invalid CSV filepath.")

	# Set group name = file name.
	group_name = unicode(os.path.basename(fp).split(".")[0])
	group_name = group_name.lower()

	# Set group.
	group = convert.csv_file_to_dict(fp)
	group = {
		u'group': group_name,
		u'columns': group[0].keys(),
		u'metrics': map(lambda m: m.values(), group)
	}

	# Invoke api.
	r = u.invoke_api(requests.post, u.EP_ADD, group)
	r = r.json()

	u.log("add-from-csv", r)


def _add_from_json(fp=None):
	"""Add a metric group from a json file."""
	# Parse csv filepath.
	if fp is None:
		fp = u.METRICS_JSON
	if not os.path.exists(fp):
		raise IOError("Invalid JSON filepath.")

	# Set group.
	group = convert.json_file_to_dict(u.METRICS_JSON)

	# Invoke api.
	r = u.invoke_api(requests.post, u.EP_ADD, group)
	r = r.json()

	u.log("add-from-json", r)


def _delete_group(group_id):
	"""Delete a metric group."""
	# Invoke api.
	r = u.invoke_api(requests.post, u.EP_DELETE_GROUP.format(group_id))
	r = r.json()

	u.log("delete-group", r)


def _delete_line(lines):
	"""Delete a metric line."""
	# Set lines.
	lines = {
		'metric_id_list': lines.split("-")
	}

	# Invoke api.
	r = u.invoke_api(requests.post, u.EP_DELETE_LINES, lines)
	r = r.json()

	u.log("delete-line", r)


def _fetch(group_id):
	"""Retrieve a metric group."""
	# Invoke api.
	r = u.invoke_api(requests.get, u.EP_FETCH.format(group_id))
	r = r.json()

	u.log("fetch", r)


def _fetch_line_count(group_id):
	"""Retrieve number of lines in a metric group."""
	# Invoke api.
	r = u.invoke_api(requests.get, u.EP_FETCH.format(group_id))
	r = r.json()

	u.log("fetch-line-count", len(r['metrics']) if 'metrics' in r else "0")


def _fetch_csv(group_id):
	"""Retrieve a metric group in CSV format."""
	# Invoke api.
	r = u.invoke_api(requests.get, u.EP_FETCH_CSV.format(group_id))
	r = r.text

	u.log("fetch-csv", "\n" + r)


def _fetch_headers(group_id):
	"""Retrieve a metric group column headers."""
	# Invoke api.
	r = u.invoke_api(requests.get, u.EP_FETCH_HEADERS.format(group_id))
	r = r.json()

	u.log("fetch-headers", r)


def _list_group():
	"""List set of metric groups."""
	# Invoke api.
	r = u.invoke_api(requests.get, u.EP_LIST_GROUP)
	r = r.json()

	u.log("list-group", r)


# Map of supported actions.
_ACTIONS = {
	"add": _add,
	"add-from-csv": _add_from_csv,
	"add-from-json": _add_from_json,
	"delete-group": _delete_group,
	"delete-line": _delete_line,
	"fetch": _fetch,
	"fetch-csv": _fetch_csv,
	"fetch-headers": _fetch_headers,
	"fetch-line-count": _fetch_line_count,
	"list-group": _list_group,
}


def _main(action, arg=None):
	"""Main entry point."""
	# Format action key.
	action = action.replace("_", "-")

	# Error if unsupported.
	if action not in _ACTIONS:
		raise NotImplementedError(action)

	# Set action.
	action = _ACTIONS[action]

	# Invoke action.
	if (arg):
		action(arg)
	else:
		action()


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1],
    	  None if len(sys.argv) <= 2 else sys.argv[2])
