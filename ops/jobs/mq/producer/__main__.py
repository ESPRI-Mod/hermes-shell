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

import ext_smtp_from_file
import ext_smtp_polling
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
define("agent_arg",
       default=None,
       help="Miscellaneous argument to be passed to producer")


# Map of producer types to producers.
_PRODUCERS = {
    'ext-smtp-from-file': ext_smtp_from_file,
    'ext-smtp-polling': ext_smtp_polling,
    'ext-smtp-realtime': ext_smtp_realtime
}

# Collection of producers with an extra argument.
_WITH_ARG = {
    ext_smtp_from_file: "Must supply email file path."
    }


# Collection of non-standard producers.
_NON_STANDARD = [ext_smtp_realtime]


def _execute_standard(producer):
    """Executes a standard producer.

    """
    # Create context.
    if options.agent_arg:
        ctx = producer.ProcessingContext(options.agent_limit,
                                         options.agent_arg)
    else:
        ctx = producer.ProcessingContext(options.agent_limit)

    # Set tasks.
    tasks = producer.get_tasks()

    # Set error tasks.
    try:
        error_tasks = producer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    # Invoke tasks.
    rt.invoke1(tasks, error_tasks=error_tasks, ctx=ctx, module="MQ")


def _execute_non_standard(producer):
    """Executes a non-standard producer.

    """
    if options.agent_arg:
        producer.execute(options.agent_limit, options.agent_arg)
    else:
        producer.execute(options.agent_limit)


def _execute():
    """Executes message producer.

    """
    # Set producer to be launched.
    try:
        producer = _PRODUCERS[options.agent_type]
    except KeyError:
        raise ValueError("Invalid producer type: {0}".format(options.agent_type))

    # Parse producer argument.
    if producer in _WITH_ARG and not options.agent_arg:
        raise ValueError(_WITH_ARG[producer])

    # Log.
    rt.log_mq("Message producer launched: {0}".format(options.agent_type))

    # Execute producer.
    if producer in _NON_STANDARD:
        _execute_non_standard(producer)
    else:
        _execute_standard(producer)


# Main entry point.
options.parse_command_line()
_execute()
