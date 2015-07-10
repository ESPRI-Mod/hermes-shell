# -*- coding: utf-8 -*-

"""
.. module:: internal_api.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends event notifications to Prodiguer web API.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import requests, json

from prodiguer import mq
from prodiguer import web
from prodiguer.utils import logger



# API endpoint to post event data to.
_API_EP = '/simulation/monitoring/event'

# API not running error message.
_ERR_API_NOT_RUNNING = "API service needs to be started."

# HTTP header inidcating that content type is json.
_JSON_HTTP_HEADER = {'content-type': 'application/json'}


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return _invoke_endpoint


def _invoke_endpoint(ctx):
    """Invokes API endpoint.

    """
    # Set API endpoint.
    endpoint = web.get_endpoint(_API_EP)

    # Log.
    logger.log_mq("Dispatching API notification: {0} to {1}".format(ctx.content,  endpoint))

    # Send event info via an HTTP POST to API endpoint.
    try:
        requests.post(endpoint,
                      data=json.dumps(ctx.content),
                      headers=_JSON_HTTP_HEADER,
                      timeout=2.0,
                      verify=False)
    except requests.exceptions.ConnectionError:
        logger.log_web_warning(_ERR_API_NOT_RUNNING)
