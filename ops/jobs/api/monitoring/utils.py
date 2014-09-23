# -*- coding: utf-8 -*-

import json

import requests

from prodiguer.utils import config, rt



# API base endpoint.
_API = {
    "dev": r"http://localhost:8888",
    "test": r"http://prodiguer-test-web.ipsl.jussieu.fr",
    "prod": r"http://prodiguer-web.ipsl.jussieu.fr"
}


def get_endpoint(route):
	"""Returns an endpoint for invocation.

	:param str route: The API url route.
	"""
	return r"{0}{1}".format(_API[config.api.mode] , route)


def invoke_api(endpoint, verb=requests.get, payload=None):
    """Invokes api endpoint.

    :param str endpoint: API endpoint to invoke.
    :param func verb: Requests HTTP verb invoker.
    :param object payload: Payload to embed with request.

    :returns: Request HTTP response wrapper.
    :rtype: requests.response

    """
    data = headers = None
    if payload:
        headers = {'content-type': 'application/json'}
        data = json.dumps(payload)

    response = verb(endpoint, data=data, headers=headers)

    return response.json()



def log(action, msg=None):
    """Logger helper function.

    :param str action: API action that is being invoked.
    :param str msg: Log message.

    """
    if not msg:
        msg = action
    else:
        msg = "{0} :: {1}".format(action, msg)
    rt.log(msg, module="MONITORING")
