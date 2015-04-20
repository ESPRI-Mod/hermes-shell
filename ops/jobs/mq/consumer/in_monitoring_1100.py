# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_1100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 1100 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv, mq
from prodiguer.db import pgres as db

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_1100


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message_content,
      _persist_simulation_state,
      _persist_job_updates,
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

        self.job_uid = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']


def _persist_simulation_state(ctx):
    """Persists simulation state to db.

    """
    db.dao_monitoring.create_simulation_state(
        ctx.simulation_uid,
        cv.constants.SIMULATION_STATE_QUEUED,
        ctx.msg.timestamp,
        MQ_QUEUE
        )


def _persist_job_updates(ctx):
    """Persists job updates to db.

    """
    updated = db.dao_monitoring.update_job_status(
        ctx.job_uid,
        ctx.msg.timestamp,
        cv.constants.JOB_STATE_COMPLETE
        )

    if not updated:
        ctx.abort = True


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": u"job_complete",
        "job_uid": unicode(ctx.job_uid),
        "simulation_uid": unicode(ctx.simulation_uid)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)
