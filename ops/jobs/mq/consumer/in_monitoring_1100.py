# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_1100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 1100 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv, db, mq

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
      _persist_job_state,
      _notify_api
      )


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(
            props, body, decode=decode)

        self.execution_end_date = None
        self.execution_state_timestamp = None
        self.job_uid = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.execution_end_date = utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.execution_state_timestamp = utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']



def _persist_job_state(ctx):
    """Persists job state to db.

    """
    db.dao_monitoring.create_job_state(
        ctx.simulation_uid,
        ctx.job_uid,
        cv.constants.JOB_STATE_COMPLETE,
        ctx.execution_state_timestamp,
        MQ_QUEUE
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    utils.notify_api_of_simulation_state_change(ctx.simulation_uid)

