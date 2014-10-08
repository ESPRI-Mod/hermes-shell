# -*- coding: utf-8 -*-

"""
.. module:: internal_api.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends event notifications to Prodiguer web API.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import requests

from prodiguer import api, mq, rt



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_INTERNAL_API

# API endpoint to post event data to.
_API_EP = '/monitoring/event'

# API not running error message.
_ERR_API_NOT_RUNNING = "API service needs to be started."


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return _notify_api


def _notify_api(ctx):
    """Message handler callback."""
    rt.log_mq("API notification: {0}".format(ctx.content))

    # Set API endpoint.
    endpoint = api.handlers.utils.get_endpoint(_API_EP)

    # Send event info via an HTTP GET to API endpoint.
    try:
        requests.get(endpoint, params=ctx.content, timeout=2.0)
    except requests.exceptions.ConnectionError:
        rt.log_api(_ERR_API_NOT_RUNNING, level=rt.LOG_LEVEL_WARNING)
