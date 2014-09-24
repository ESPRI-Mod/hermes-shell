# -*- coding: utf-8 -*-

"""
.. module:: in_log.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Logs messages dispatched to Prodiguer MQ server (exchange=x-in).

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_LOG

# Flag indicating whether messages will be persisted or not.
PERSIST_MESSAGE = False


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return _log_message


def _log_message(ctx):
    """Message handler callback."""
    # TODO: log x-in message
    pass
    # print "TODO: log x-in message: {0}".format(ctx.properties.message_id)
