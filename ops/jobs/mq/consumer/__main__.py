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
    """Initializes a consumer prior to message consumption."""
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
    """Processes a message being consumed from a queue."""
    # Set tasks to be invoked.
    tasks = consumer.get_tasks()
    try:
        error_tasks = consumer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    rt.invoke1(tasks, error_tasks=error_tasks, ctx=msg, module="MQ")


# Set consumer to be launched.
try:
    _consumer_type = sys.argv[1]
except IndexError:
    raise ValueError("Consumer type is mandatory")
else:
    try:
        consumer = _CONSUMERS[_consumer_type]
    except KeyError:
        raise ValueError("Invalid consumer type: {0}".format(_consumer_type))

# Limit on number of message to consumer (0 = no limit).
try:
    _consume_limit = int(sys.argv[2])
except IndexError:
    _consume_limit = 0
except ValueError:
    raise ValueError("Invalid consume limit - it must be an integer >= 0")


# Set flag indicating whether consumer require db session.
_is_db_bound = _consumer_type not in _NON_DB_BOUND_CONSUMERS

# Set flag indicating whether message will be presisted to db.
try:
    _auto_persist = consumer.PERSIST_MESSAGE
except AttributeError:
    _auto_persist = True

# Set processing context information type.
try:
    _context_type = consumer.Message
except AttributeError:
    _context_type = mq.Message

# Connect to db.
if _is_db_bound:
    db.session.start(config.db.pgres.main)
    db.cache.load()

# Initialise.
_initialize_consumer(consumer)

# Log.
rt.log_mq("launched consumer: {0}".format(_consumer_type))

# Consume messages.
try:
    mq.utils.consume(consumer.MQ_EXCHANGE,
                     consumer.MQ_QUEUE,
                     lambda ctx: _process_message(ctx, consumer),
                     auto_persist=_auto_persist,
                     consume_limit=_consume_limit,
                     context_type=_context_type,
                     verbose=_consume_limit > 0)
except:
    # Disconnect from db.
    if _is_db_bound:
        db.session.end()
