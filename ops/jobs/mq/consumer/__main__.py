# -*- coding: utf-8 -*-

"""
.. module:: __main__.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Main entry point for launching message consumers.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import sys

from tornado.options import define, options

from prodiguer import config, db, mq, rt

# External queue consumers.
import ext_smtp

# Input queue queue consumers.
import in_monitoring
import in_monitoring_0000
import in_monitoring_0100
import in_monitoring_1000
import in_monitoring_1100
import in_monitoring_2000
import in_monitoring_3000
import in_monitoring_7000
import in_monitoring_8888
import in_monitoring_9000
import in_monitoring_9999

# Internal queue consumers.
import internal_api
import internal_smtp
import internal_sms



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
    'in-monitoring-8888': in_monitoring_8888,
    'in-monitoring-9000': in_monitoring_9000,
    'in-monitoring-9999': in_monitoring_9999,
}

# Map of consumer types to consumers that do not require binding to backend database.
_NON_DB_BOUND_CONSUMERS = {}


def _initialize_consumer(consumer):
    """Initializes a consumer prior to message consumption.

    """
    # Set collection of initialization tasks.
    try:
        tasks = consumer.get_init_tasks()
    except AttributeError:
        return

    # Convert to iterable (if necessary).
    try:
        iter(tasks)
    except TypeError:
        tasks = (tasks, )

    # Execute initialization tasks.
    for task in tasks:
        task()


def _process_message(msg, consumer):
    """Processes a message being consumed from a queue.

    """
    # Set tasks to be invoked.
    tasks = consumer.get_tasks()
    try:
        error_tasks = consumer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    rt.invoke1(tasks, error_tasks=error_tasks, ctx=msg, module="MQ")


class _ConsumerExecutionInfo(object):
    """Encapsulates information required to runa consumer.

    """
    def __init__(self, consumer_type):
        self.consumer = None
        self.consumer_type = consumer_type
        self.is_db_bound = consumer_type not in _NON_DB_BOUND_CONSUMERS
        self.auto_persist = True
        self.context_type = mq.Message


    @staticmethod
    def create(consumer_type):
        """Creates an instance.

        :param str consumer_type: Type of consumer being executed.

        :returns: Consumer execution information.
        :rtype: _ConsumerExecutionInfo

        """
        instance = _ConsumerExecutionInfo(consumer_type)

        # Set consumer to be launched.
        try:
            instance.consumer = _CONSUMERS[options.agent_type]
        except KeyError:
            raise ValueError("Invalid consumer type: {0}".format(options.agent_type))

        # Override default flag indicating whether message will be presisted to db.
        try:
            instance.auto_persist = instance.consumer.PERSIST_MESSAGE
        except AttributeError:
            pass

        # Override default processing context information type.
        try:
            instance.context_type = instance.consumer.Message
        except AttributeError:
            pass

        return instance


def _execute():
    """Executes message consumer.

    """
    # Get execution info.
    exec_info = _ConsumerExecutionInfo.create(options.agent_type)

    # Connect to db.
    if exec_info.is_db_bound:
        db.session.start(config.db.pgres.main)
        db.cache.load()

    # Initialise.
    _initialize_consumer(exec_info.consumer)

    # Log.
    rt.log_mq("launched consumer: {0}".format(options.agent_type))

    # Consume messages.
    try:
        mq.utils.consume(exec_info.consumer.MQ_EXCHANGE,
                         exec_info.consumer.MQ_QUEUE,
                         lambda ctx: _process_message(ctx, exec_info.consumer),
                         auto_persist=exec_info.auto_persist,
                         consume_limit=options.agent_limit,
                         context_type=exec_info.context_type,
                         verbose=options.agent_limit > 0)
    except:
        if exec_info.is_db_bound:
            db.session.end()


# Main entry point.
options.parse_command_line()
_execute()
