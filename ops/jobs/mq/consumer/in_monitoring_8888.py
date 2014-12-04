# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_8888.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 8888 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_8888


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message,
      _process_message
      )


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(Message, self).__init__(props, body, decode=decode)

        self.simulation_uid = None


def _unpack_message(ctx):
    """Unpacks message being processed.

    """
    ctx.simulation_uid = ctx.content['simuid']


def _process_message(ctx):
    """Processes message.

    """
    pass
