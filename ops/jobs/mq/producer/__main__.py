# -*- coding: utf-8 -*-

"""
.. module:: __main__.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Main entry point for launching message producers.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import logging

from tornado.options import define, options

from prodiguer import rt
from prodiguer.utils import logger

import ext_smtp_realtime



# Set logging options.
logging.getLogger("pika").setLevel(logging.ERROR)


# Define command line arguments.
define("agent_type",
       help="Type of message producer to launch")
define("agent_limit",
       default=0,
       help="Production limit (0 = unlimited)",
       type=int)


# Map of producer types to producers.
_PRODUCERS = {
    'ext-smtp-realtime': ext_smtp_realtime
}


# Set of non-standard producers.
_NON_STANDARD = { ext_smtp_realtime }


def _execute_standard(producer):
    """Executes a standard producer.

    """
    # Create context.
    ctx = producer.ProcessingContext(options.agent_limit)

    # Set tasks.
    tasks = producer.get_tasks()

    # Set error tasks.
    try:
        error_tasks = producer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    # Invoke tasks.
    rt.invoke_mq(options.agent_type, tasks, error_tasks=error_tasks, ctx=ctx)


def _execute_non_standard(producer):
    """Executes a non-standard producer.

    """
    producer.execute(options.agent_limit)


def _execute():
    """Executes message producer.

    """
    # Set producer to be launched.
    try:
        producer = _PRODUCERS[options.agent_type]
    except KeyError:
        raise ValueError("Invalid producer type: {0}".format(options.agent_type))

    # Log.
    logger.log_mq("Message producer launched: {0}".format(options.agent_type))

    # Execute producer.
    executor = _execute_non_standard if producer in _NON_STANDARD else _execute_standard
    executor(producer)


# Main entry point.
options.parse_command_line()
_execute()
