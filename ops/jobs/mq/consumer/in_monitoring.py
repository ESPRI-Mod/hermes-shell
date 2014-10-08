# -*- coding: utf-8 -*-

"""
.. module:: internal_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends notifications to an SMTP server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq, rt

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



# Map of sub-consumer types to sub-consumers.
_SUB_CONSUMERS = {
    '0000': in_monitoring_0000,
    '0100': in_monitoring_0100,
    '1000': in_monitoring_1000,
    '1100': in_monitoring_1100,
    '2000': in_monitoring_2000,
    '3000': in_monitoring_3000,
    '7000': in_monitoring_7000,
    '8888': in_monitoring_8888,
    '9000': in_monitoring_9000,
    '9999': in_monitoring_9999,
}


# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING



# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.sub_consumer = _SUB_CONSUMERS[self.content['msgCode']]
        self.sub_message = self.sub_consumer.Message(props, body)


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return _process


def _process(ctx):
    """Dispatches an sms to an operator."""
    # Set tasks to be invoked.
    tasks = ctx.sub_consumer.get_tasks()
    try:
        error_tasks = ctx.sub_consumer.get_error_tasks()
    except AttributeError:
        error_tasks = None

    rt.invoke1(tasks, error_tasks=error_tasks, ctx=ctx.sub_message, module="MQ")
