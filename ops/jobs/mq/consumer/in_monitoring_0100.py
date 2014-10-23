# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0100 messages.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import db, mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0100


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _unpack_message,
        _persist_simulation_updates,
        _persist_simulation_state,
        _dispatch_notifications
    )


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body, decode=True):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=decode)

        self.simulation_uid = None
        self.execution_state_timestamp = None


def _unpack_message(ctx):
    """Unpacks message being processed.

    """
    ctx.simulation_uid = ctx.content['simuid']
    ctx.execution_end_date = utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.execution_state_timestamp = utils.get_timestamp(ctx.props.headers['timestamp'])


def _persist_simulation_updates(ctx):
    """Persists simulation updates to db.

    """
    pass


def _persist_simulation_state(ctx):
    """Persists simulation state to db.

    """
    mq.db_hooks.create_simulation_state(
        ctx.simulation_uid,
        db.constants.EXECUTION_STATE_COMPLETE,
        ctx.execution_state_timestamp,
        MQ_QUEUE
        )


def _dispatch_notifications(ctx):
    """Dispatches notifications to various internal services.

    """
    pass
