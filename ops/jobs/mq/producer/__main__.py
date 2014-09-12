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
import ext_smtp
import ext_smtp_from_file



# Map of producer types to producers.
_PRODUCERS = {
    'ext-smtp': ext_smtp,
    'ext-smtp-from-file': ext_smtp_from_file
}


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

# Log.
rt.log_mq("Message producer launched: {0}".format(_producer_type))

# Invoke tasks.
rt.invoke(_producer.TASKS, _producer.ProcessingContext(_throttle), "MQ")
