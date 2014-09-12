# -*- coding: utf-8 -*-

# Module imports.
import json
import os
import sys
from collections import namedtuple

import requests

from prodiguer.utils import (
    convert,
    config as cfg,
    runtime as rt
    )



# Map of API base endpoint and execution modes.
_API = {
    "dev": r"http://localhost:8888",
    "test": r"http://prodiguer-test-web.ipsl.jussieu.fr",
    "prod": r"http://prodiguer-web.ipsl.jussieu.fr"
}

# Metric API endpoints.
_EP = _API[cfg.api.mode] + r"/api/1/metric"
_EP_ADD = _EP + r"/add"
_EP_LIST_GROUP = _EP + r"/list_group"
_EP_FETCH = _EP + r"/fetch?group={0}&format={1}"
_EP_FETCH_SETUP = _EP + r"/fetch_setup?group={0}"
_EP_FETCH_LINE_COUNT = _EP + r"/fetch_line_count?group={0}"
_EP_FETCH_HEADERS = _EP + r"/fetch?group={0}&headersonly=true"
_EP_DELETE_LINES = _EP + r"/delete"
_EP_DELETE_GROUP = _EP + r"/delete_group?group={0}"

# Supported file extensions.
_ENCODING_CSV = "csv"
_ENCODING_JSON = "json"
_ENCODINGS = (_ENCODING_CSV, _ENCODING_JSON)

# Processing context information.
_ProcessingContextInfo = namedtuple('ProcessingContext',
                                    ['action', 'arg1', 'arg2'])



def _log(action, msg=None):
    """Logger helper function."""
    if not msg:
        msg = action
    else:
        msg = "{0} :: {1}".format(action, msg)
    rt.log(msg, module="METRIC")


def _invoke_api(verb, ep, payload=None):
    """Invokes api endpoint."""
    data = headers = None
    if payload:
        headers = {'content-type': 'application/json'}
        data = json.dumps(payload)

    return verb(ep, data=data, headers=headers)


def _get_group_from_csv_file(fp):
    """Returns a metric group from a local csv file."""
    # Set group name = file name.
    group_name = unicode(os.path.basename(fp).split(".")[0])
    group_name = group_name.lower()

    # Set group.
    group = convert.csv_file_to_dict(fp)
    group = {
        u'group': group_name,
        u'columns': group[0].keys(),
        u'metrics': [m.values() for m in group]
    }

    return group


def _get_group_from_json_file(fp):
    """Returns a metric group from a local json file."""
    return convert.json_file_to_dict(fp)


# Map of supported group factories.
_GROUP_FACTORIES = {
    _ENCODING_CSV: _get_group_from_csv_file,
    _ENCODING_JSON: _get_group_from_json_file
}


def _parse_group_id(group_id):
    """Parses group id."""
    group_id = str(group_id).lower() if group_id is not None else None
    if group_id is None:
        raise ValueError("group_id is undefined.")

    return group_id


def _parse_encoding(encoding, default=None):
    """Parses encoding."""
    encoding = str(encoding).lower() if encoding is not None else None
    encoding = encoding or default
    if encoding not in _ENCODINGS:
        err = "Invalid metrics encoding ({0}). "
        err = err + "The following encodings are supported : {1}."
        raise ValueError(err.format(encoding, _ENCODINGS))

    return encoding


def _parse_filepath(fp):
    """Parses filepath."""
    err = None
    if not os.path.exists(fp):
        err = "Invalid file path."
    if not err:
        if not os.path.isfile(fp):
            err = "File path does not point to a file."
    if err:
        raise IOError(err)

    return fp


def _add(ctx):
    """Adds a metric group from either a local file or a url."""
    # Extract params.
    filepath = _parse_filepath(ctx.arg1)
    encoding = _parse_encoding(os.path.splitext(filepath)[1][1:])

    # Set group.
    factory = _GROUP_FACTORIES[encoding]
    group = factory(filepath)

    # Invoke api.
    r = _invoke_api(requests.post, _EP_ADD, group)
    r = r.json()

    _log("add", r)


def _delete_group(ctx):
    """Delete a metric group."""
    # Parse params.
    group_id = _parse_group_id(ctx.arg1)

    # Invoke api.
    r = _invoke_api(requests.post, _EP_DELETE_GROUP.format(group_id))
    r = r.json()

    _log("delete-group", r)


def _delete_line(ctx):
    """Delete a metric line."""
    # Extract params.
    lines = ctx.arg1

    # Set lines.
    lines = {
        'metric_id_list': lines.split("-")
    }

    # Invoke api.
    r = _invoke_api(requests.post, _EP_DELETE_LINES, lines)
    r = r.json()

    _log("delete-line", r)


def _fetch(ctx):
    """Retrieve a metric group."""
    # Parse params.
    group_id = _parse_group_id(ctx.arg1)
    encoding = _parse_encoding(ctx.arg2, _ENCODING_JSON)

    # Invoke api.
    r = _invoke_api(requests.get, _EP_FETCH.format(group_id, encoding))
    r = r.text

    _log("fetch", r)


def _fetch_line_count(ctx):
    """Retrieve number of lines in a metric group."""
    # Parse params.
    group_id = _parse_group_id(ctx.arg1)

    # Invoke api.
    r = _invoke_api(requests.get, _EP_FETCH_LINE_COUNT.format(group_id))
    r = r.json()

    if 'error' in r:
        _log("fetch-line-count", r['error'])
    else:
        _log("fetch-line-count", r['count'])


def _fetch_setup(ctx):
    """Retrieve metric group setup information used to drive UI's."""
    # Parse params.
    group_id = _parse_group_id(ctx.arg1)

    # Invoke api.
    r = _invoke_api(requests.get, _EP_FETCH_SETUP.format(group_id))
    r = r.json()

    if 'error' in r:
        _log("fetch-setup", r['error'])
    else:
        _log("fetch-setup", r['data'])


def _fetch_headers(ctx):
    """Retrieve a metric group column headers."""
    # Parse params.
    group_id = _parse_group_id(ctx.arg1)

    # Invoke api.
    r = _invoke_api(requests.get, _EP_FETCH_HEADERS.format(group_id))
    r = r.json()

    _log("fetch-headers", r)


def _list_group(ctx):
    """List set of metric groups."""
    # Invoke api.
    r = _invoke_api(requests.get, _EP_LIST_GROUP)
    r = r.json()

    _log("list-group", r)


# Map of actions to functions.
_ACTIONS = {
    "add": _add,
    "delete-group": _delete_group,
    "delete-line": _delete_line,
    "fetch": _fetch,
    "fetch-headers": _fetch_headers,
    "fetch-setup": _fetch_setup,
    "fetch-line-count": _fetch_line_count,
    "list-group": _list_group,
}


def _main(action, arg1=None, arg2=None):
    """Main entry point."""
    # Create context.
    ctx = _ProcessingContextInfo(action, arg1, arg2)

    # Validate action.
    action = str(ctx.action).replace("_", "-")
    if action not in _ACTIONS:
        raise NotImplementedError(action)

    # Invoke action.
    _ACTIONS[action](ctx)


if __name__ == '__main__':
    _main(None if len(sys.argv) <= 1 else sys.argv[1],
          None if len(sys.argv) <= 2 else sys.argv[2],
          None if len(sys.argv) <= 3 else sys.argv[3])
