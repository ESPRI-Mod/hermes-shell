# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_4900.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 4900 messages: pop stack failure.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv, mq
from prodiguer.db import pgres as db

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_4900


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message_content,
      _persist_job_updates
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


def _persist_job_updates(ctx):
    """Persists job updates to db.

    """
    job = db.dao_monitoring.retrieve_job(ctx.job_uid)
    if not job or job.is_error:
        ctx.abort = True
    else:
        job.execution_end_date = ctx.msg.timestamp
        job.is_error = True
        db.session.update(job)


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": u"job_error",
        "job_uid": unicode(ctx.job_uid),
        "simulation_uid": unicode(ctx.simulation_uid)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)
