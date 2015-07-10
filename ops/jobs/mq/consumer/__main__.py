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

from prodiguer import cv
from prodiguer import mq
from prodiguer.utils import logger
from prodiguer.utils import rt
from prodiguer.db import pgres as db

import ext_smtp
import in_metrics_env
import in_metrics_sim
import in_monitoring
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
import internal_api
import internal_cv
import null_consumer



# Set logging options.
logging.getLogger("pika").setLevel(logging.ERROR)
logging.getLogger("requests").setLevel(logging.ERROR)


# Define command line options.
define("agent_type",
       help="Type of message consumer to lanuch",
       type=str)
define("agent_limit",
       default=0,
       help="Consumption limit (0 = unlimited)",
       type=int)

# Map of consumer types to consumers.
_CONSUMERS = {
    # Production queues.
    'ext-smtp': ext_smtp,
    'internal-api': internal_api,
    'internal-cv': internal_cv,
    'in-monitoring-compute': in_monitoring,
    'in-monitoring-post-processing': in_monitoring,
    'in-metrics-env': in_metrics_env,
    'in-metrics-sim': in_metrics_sim,
    # Test queues.
    'in-monitoring-0000': in_monitoring_0000,
    'in-monitoring-0100': in_monitoring_0100,
    'in-monitoring-1000': in_monitoring_1000,
    'in-monitoring-1100': in_monitoring_1100,
    'in-monitoring-2000': in_monitoring_2000,
    'in-monitoring-2100': in_monitoring_2100,
    'in-monitoring-2900': in_monitoring_2900,
    'in-monitoring-3000': in_monitoring_3000,
    'in-monitoring-3100': in_monitoring_3100,
    'in-monitoring-3900': in_monitoring_3900,
    'in-monitoring-4000': null_consumer,
    'in-monitoring-4100': null_consumer,
    'in-monitoring-4900': in_monitoring_4900,
    'in-monitoring-7000': in_metrics_env,
    'in-monitoring-7100': in_metrics_sim,
    'in-monitoring-8888': null_consumer,
    'in-monitoring-9000': in_monitoring_4900,   # TODO - deprecate
    'in-monitoring-9999': in_monitoring_9999,
    'debug-internal-api': internal_api,
    'debug-internal-cv': internal_cv,
    'debug-ext-smtp': ext_smtp
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
    """Encapsulates information required to run an agent.

    """
    def __init__(self, consumer_type):
        """Object constructor.

        """
        self.consumer = None
        self.consumer_type = consumer_type
        self.context_type = mq.Message

        # Derive exchange from consumer type.
        parts = consumer_type.split('-')
        if len(parts) <= 1:
            raise ValueError("Invalid consumer type: {0}".format(consumer_type))
        mq_exchange = parts[1] if parts[0] == 'debug' else parts[0]
        self.mq_exchange = "x-{}".format(mq_exchange)


    @staticmethod
    def create(consumer_type):
        """Creates an instance.

        :param str consumer_type: Type of consumer being executed.

        :returns: Consumer execution information.
        :rtype: _ConsumerExecutionInfo

        """
        # Strip irrelevant prefix.
        if consumer_type.startswith('q-'):
            consumer_type = consumer_type[2:]

        # Instantiate.
        instance = _ConsumerExecutionInfo(consumer_type)

        # Set consumer to be launched.
        try:
            instance.consumer = _CONSUMERS[consumer_type]
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
    logger.log_mq("launching consumer: {0}".format(options.agent_type))

    try:
        mq.utils.consume(exec_info.mq_exchange,
                         "q-{0}".format(exec_info.consumer_type),
                         lambda ctx: _process(exec_info, ctx),
                         consume_limit=options.agent_limit,
                         context_type=exec_info.context_type,
                         verbose=options.agent_limit > 0)
    finally:
        db.session.end()


# Main entry point.
_execute()
