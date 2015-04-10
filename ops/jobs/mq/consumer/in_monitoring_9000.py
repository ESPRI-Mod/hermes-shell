# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_9000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 9000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv, mq
from prodiguer.db import pgres as db

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_9000


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message_content,
        _persist_job_state
        )


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(
            props, body, decode=decode)

        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']


def _persist_job_state(ctx):
    """Persists job state to db.

    """
    db.dao_monitoring.create_job_state(
        ctx.simulation_uid,
        ctx.job_uid,
        cv.constants.JOB_STATE_ERROR,
        ctx.msg.timestamp,
        MQ_QUEUE
        )
