# -*- coding: utf-8 -*-

"""
.. module:: __main__.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Main entry point for launching message producers.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import sys

from prodiguer import rt

# External queue producers.
import ext_smtp_from_file
import ext_smtp_polling
import ext_smtp_realtime



# Map of producer types to producers.
_PRODUCERS = {
    'ext-smtp-from-file': ext_smtp_from_file,
    'ext-smtp-polling': ext_smtp_polling,
    'ext-smtp-realtime': ext_smtp_realtime
}

# Collection of non-standard producers.
_NON_STANDARD = [ext_smtp_realtime]

# Set producer to be launched.
try:
    _producer_type = sys.argv[1]
except IndexError:
    raise ValueError("Consumer type is mandatory")
else:
    try:
        _producer = _PRODUCERS[_producer_type]
    except KeyError:
        raise ValueError("Invalid producer type: {0}".format(_producer_type))

# Limit on number of message to produce (0 = no limit).
try:
    _throttle = int(sys.argv[2])
except IndexError:
    _throttle = 0
except ValueError:
    raise ValueError("Invalid produce limit - it must be an integer >= 0")

# Miscellaneous argument.
try:
    _arg = sys.argv[3]
except IndexError:
    _arg = None

# Log.
rt.log_mq("Message producer launched: {0}".format(_producer_type))

# Execute non-standard producers.
if _producer in _NON_STANDARD:
    if _arg:
        _producer.execute(_throttle, _arg)
    else:
        _producer.execute(_throttle)

# Execute standard producers.
else:
    # Create context.
    if _arg:
        ctx = _producer.ProcessingContext(_throttle, _arg)
    else:
        ctx = _producer.ProcessingContext(_throttle)

    # Set tasks.
    tasks = _producer.get_tasks()

    # Set error tasks.
    try:
        error_tasks = _producer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    # Invoke tasks.
    rt.invoke1(tasks, error_tasks=error_tasks, ctx=ctx, module="MQ")
