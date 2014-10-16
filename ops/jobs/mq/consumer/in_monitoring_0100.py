# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0100 messages.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import convert, db, mq
from prodiguer.db.constants import EXECUTION_STATE_COMPLETE

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0100


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body, decode=True):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=decode)

        self.simulation = None
        self.simulation_uid = self.content['simuid']


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _update_simulation_state,
        _persist_simulation_message,
        _notify_operator
        )


def _update_simulation_state(ctx):
    """Updates simulation status."""
    utils.update_simulation_state(ctx, EXECUTION_STATE_COMPLETE)


def _persist_simulation_message(ctx):
    """Persists simulation message information to db."""
    db.mq_hooks.create_simulation_message(ctx.simulation.id, ctx.msg.id)


def _notify_operator(ctx):
    """Notifies an operator that simulation has completed."""
    utils.notify_operator(ctx, "monitoring-0100")
