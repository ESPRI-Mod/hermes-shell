# -*- coding: utf-8 -*-

"""
.. module:: in_monitoring.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Processes simulation monitoring related messages (by delegation).

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq
from prodiguer import rt
from prodiguer.utils import logger

import in_monitoring_0000
import in_monitoring_0100
import in_monitoring_1000
import in_monitoring_1100
import in_monitoring_2000
import in_monitoring_2100
import in_monitoring_2900
import in_monitoring_3000
import in_monitoring_3100
import in_monitoring_3900
import in_monitoring_4900
import in_monitoring_9999
import null_consumer


# Map of sub-consumer types to sub-consumers.
_SUB_CONSUMERS = {
    # Simulation messages.
    '0000': in_monitoring_0000,
    '0100': in_monitoring_0100,
    '9999': in_monitoring_9999,
    # Computing job messages.
    '1000': in_monitoring_1000,
    '1100': in_monitoring_1100,
    # Post processing job messages.
    '2000': in_monitoring_2000,
    '2100': in_monitoring_2100,
    '2900': in_monitoring_2900,
    # Post processing from checker job messages.
    '3000': in_monitoring_3000,
    '3100': in_monitoring_3100,
    '3900': in_monitoring_3900,
    # Command messages.
    '4000': null_consumer,
    '4100': null_consumer,
    '4900': in_monitoring_4900,
    '9000': in_monitoring_4900,  # TODO-DEPRECATE
    # Other messages.
    '8888': null_consumer
}

# Set of auotmatically loggable consumers.
# N.B. these are used during development.
_LOGGABLE_CONSUMERS = {}


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return _process


def _process(ctx):
    """Processes a simulation monitoring message pulled from message queue.

    """
    # Decode message content.
    ctx.decode()

    # Log significant messages.
    if ctx.props.type in _LOGGABLE_CONSUMERS:
        msg = "Processing message of type {}".format(ctx.props.type)
        logger.log_mq(msg)

    # Set sub-consumer.
    sub_consumer = _SUB_CONSUMERS[ctx.props.type]

    # Set sub-context.
    sub_ctx = sub_consumer.ProcessingContextInfo(ctx.props, ctx.content, decode=False)
    sub_ctx.msg = ctx.msg

    # Set tasks to be invoked.
    tasks = sub_consumer.get_tasks()
    try:
        error_tasks = sub_consumer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    # Invoke tasks.
    rt.invoke_mq(ctx.props.type, tasks, error_tasks=error_tasks, ctx=sub_ctx)
