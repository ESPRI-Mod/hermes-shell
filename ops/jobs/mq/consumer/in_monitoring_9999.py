# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_9999.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 9999 messages.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq
from prodiguer.db.constants import EXECUTION_STATE_ERROR

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_9999


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.simulation = None
        self.simulation_uid = self.content['simuid']


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        lambda ctx: utils.update_simulation_state(ctx, EXECUTION_STATE_ERROR),
        lambda ctx: utils.notify_operator(ctx, "monitoring-9999")
        )
