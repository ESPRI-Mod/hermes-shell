# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_1000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 1000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq
from prodiguer.db import pgres as db
from prodiguer.utils import config

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_1000


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message_content,
      _persist_job,
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
        self.job_warning_delay = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.job_uid = ctx.content['jobuid']
    ctx.job_warning_delay = ctx.content.get(
        'jobWarningDelay', config.monitoring.defaultJobWarningDelayInSeconds)
    ctx.simulation_uid = ctx.content['simuid']


def _persist_job(ctx):
    """Persists job info to db.

    """
    db.dao_monitoring.persist_job_01(
        ctx.job_warning_delay,
        ctx.msg.timestamp,
        ctx.job_uid,
        ctx.simulation_uid
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": u"job_start",
        "job_uid": unicode(ctx.job_uid),
        "simulation_uid": unicode(ctx.simulation_uid)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)
