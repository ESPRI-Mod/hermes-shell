# -*- coding: utf-8 -*-

"""
.. module:: __main__.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Main entry point for launching message consumers.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import logging

from tornado.options import define, options

from prodiguer import cv, mq, rt
from prodiguer.db import pgres as db

import ext_smtp
import in_monitoring
import in_monitoring_0000
import in_monitoring_0100
import in_monitoring_1000
import in_monitoring_1100
import in_monitoring_2000
import in_monitoring_3000
import in_monitoring_7000
import in_monitoring_7100
import in_monitoring_8888
import in_monitoring_9000
import in_monitoring_9999
import internal_api
import internal_cv
import internal_smtp
import internal_sms



# Set logging options.
logging.getLogger("pika").setLevel(logging.ERROR)
logging.getLogger("requests").setLevel(logging.ERROR)


# Define command line options.
define("agent_type",
       help="Type of message consumer to lanuch")
define("agent_limit",
       default=0,
       help="Consumption limit (0 = unlimited)",
       type=int)

# Map of consumer types to consumers.
_CONSUMERS = {
    'ext-smtp': ext_smtp,
    'internal-api': internal_api,
    'internal-cv': internal_cv,
    'internal-smtp': internal_smtp,
    'internal-sms': internal_sms,
    'in-monitoring': in_monitoring,
    'in-monitoring-0000': in_monitoring_0000,
    'in-monitoring-0100': in_monitoring_0100,
    'in-monitoring-1000': in_monitoring_1000,
    'in-monitoring-1100': in_monitoring_1100,
    'in-monitoring-2000': in_monitoring_2000,
    'in-monitoring-3000': in_monitoring_3000,
    'in-monitoring-7000': in_monitoring_7000,
    'in-monitoring-7100': in_monitoring_7100,
    'in-monitoring-8888': in_monitoring_8888,
    'in-monitoring-9000': in_monitoring_9000,
    'in-monitoring-9999': in_monitoring_9999,
}


def _initialize_consumer(consumer):
    """Initializes a consumer prior to message consumption.

    """
    # Set initialization tasks.
    try:
        tasks = consumer.get_init_tasks()
    except AttributeError:
        return

    # Convert to iterable.
    try:
        iter(tasks)
    except TypeError:
        tasks = (tasks, )

    # Execute.
    for task in tasks:
        task()


def _process(exec_info, ctx):
    """Processes a message being consumed from a queue.

    """
    # Set tasks.
    tasks = exec_info.consumer.get_tasks()

    # Set error tasks.
    try:
        error_tasks = exec_info.consumer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    # Execute.
    rt.invoke_mq(exec_info.consumer_type, tasks, error_tasks=error_tasks, ctx=ctx)


class _ConsumerExecutionInfo(object):
    """Encapsulates information required to runa consumer.

    """
    def __init__(self, consumer_type):
        """Object constructor.

        """
        self.consumer = None
        self.consumer_type = consumer_type
        self.context_type = mq.Message


    @staticmethod
    def create(consumer_type):
        """Creates an instance.

        :param str consumer_type: Type of consumer being executed.

        :returns: Consumer execution information.
        :rtype: _ConsumerExecutionInfo

        """
        # Instantiate.
        instance = _ConsumerExecutionInfo(consumer_type)

        # Set consumer to be launched.
        try:
            instance.consumer = _CONSUMERS[options.agent_type]
        except KeyError:
            raise ValueError("Invalid consumer type: {0}".format(options.agent_type))

        # Set processing context information type.
        try:
            instance.context_type = instance.consumer.ProcessingContextInfo
        except AttributeError:
            pass

        return instance


def _execute():
    """Executes message consumer.

    """
    # Parse command line options.
    options.parse_command_line()

    # Get execution info.
    exec_info = _ConsumerExecutionInfo.create(options.agent_type)

    # Start db session.
    db.session.start()

    # Initialise cv session.
    cv.session.init()

    # Initialise.
    _initialize_consumer(exec_info.consumer)

    # Log.
    rt.log_mq("launching consumer: {0}".format(options.agent_type))

    try:
        mq.utils.consume(exec_info.consumer.MQ_EXCHANGE,
                         "q-{0}".format(options.agent_type),
                         lambda ctx: _process(exec_info, ctx),
                         consume_limit=options.agent_limit,
                         context_type=exec_info.context_type,
                         verbose=options.agent_limit > 0)
    finally:
        db.session.end()


# Main entry point.
_execute()
