# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_1100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 1100 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import db, mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_1100


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message_content,
      _persist_job_updates,
      _persist_job_state
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
        self.execution_end_date = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.simulation_uid = ctx.content['simuid']
    ctx.execution_end_date = utils.get_timestamp(ctx.props.headers['timestamp'])


def _persist_job_updates(ctx):
    """Persists job updates to db.

    """
    pass


def _persist_job_state(ctx):
    """Persists job status to db.

    """
    pass
