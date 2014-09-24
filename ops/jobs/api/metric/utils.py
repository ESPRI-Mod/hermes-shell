# -*- coding: utf-8 -*-

import json

import requests

from prodiguer.utils import config, rt



# API base endpoint.
_API = {
    "dev": r"http://localhost:8888",
    "test": r"https://prodiguer-test-web.ipsl.jussieu.fr",
    "prod": r"https://prodiguer-web.ipsl.jussieu.fr"
}

# Supported file extensions.
_ENCODING_CSV = "csv"
_ENCODING_JSON = "json"
_ENCODINGS = (_ENCODING_CSV, _ENCODING_JSON)


def get_endpoint(route):
	"""Returns an endpoint for invocation.

	:param str route: The API url route.
	"""
	return r"{0}{1}".format(_API[config.api.mode] , route)


def invoke_api(endpoint, verb=requests.get, payload=None, expecting_json=True):
    """Invokes api endpoint.

    :param str endpoint: API endpoint to invoke.
    :param func verb: Requests HTTP verb invoker.
    :param object payload: Payload to embed with request.
    :param bool expecting_json: Flag indicating whether json is expected as response.

    :returns: Request HTTP response wrapper.
    :rtype: requests.response

    """
    data = headers = None
    if payload:
        headers = {'content-type': 'application/json'}
        data = json.dumps(payload)

    response = verb(endpoint, data=data, headers=headers)

    return response.json() if expecting_json else response.text


def parse_group_id(group_id):
    """Parses group id.

    :param str group_id: ID of a metric group.

    :returns: Parsed metric group ID.
    :rtype: str

    """
    if group_id:
        group_id = str(group_id).strip().lower()
    if not group_id:
        raise ValueError("group_id is undefined.")

    return group_id


def parse_encoding(encoding):
    """Parses encoding.

    :param str encoding: A metric encoding.

    :returns: Parsed metric encoding.
    :rtype: str

    """
    if encoding:
        encoding = str(encoding).lower()
    encoding = encoding or _ENCODING_JSON
    if encoding not in _ENCODINGS:
        err = "Invalid metrics encoding ({0}). "
        err = err + "The following encodings are supported : {1}."
        raise ValueError(err.format(encoding, _ENCODINGS))

    return encoding


def parse_boolean(val):
    """Parses a boolean string value.

    :param str val: A string representing a boolean value.

    :returns: Parsed boolean value.
    :rtype: str

    """
    val = str(val).strip()
    if val in ['', 'f', 'false', 'False', '0']:
        return 'false'
    return 'true'


def log(action, msg=None):
    """Logger helper function.

    :param str action: Metric API action that is being invoked.
    :param str msg: Log message.

    """
    if not msg:
        msg = action
    else:
        msg = "{0} :: {1}".format(action, msg)
    rt.log(msg, module="METRIC")


def log_error(action, error):
    """Error logger helper function.

    :param str action: Metric API action that is being invoked.
    :param str error: Error message.

    """
    msg = "{0} :: !!! ERROR !!! {1}".format(action, error)
    rt.log(msg, module="METRIC")