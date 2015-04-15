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

from prodiguer import mq, rt
from prodiguer.api import handler_utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_INTERNAL_API

# API endpoint to post event data to.
_API_EP = '/monitoring/event'

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
    rt.log_mq("Dispatching API notification: {0}".format(ctx.content))

    # Set API endpoint.
    endpoint = handler_utils.get_endpoint(_API_EP)

    # Send event info via an HTTP POST to API endpoint.
    try:
        requests.post(endpoint,
                      data=json.dumps(ctx.content),
                      headers=_JSON_HTTP_HEADER,
                      timeout=2.0)
    except requests.exceptions.ConnectionError:
        rt.log_api_warning(_ERR_API_NOT_RUNNING)
