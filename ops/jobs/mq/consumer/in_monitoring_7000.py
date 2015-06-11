# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_7000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 7000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq
from prodiguer.db import pgres as db

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_7000


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
      _unpack_message_content,
      _persist_metrics
      )


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(
            props, body, decode=decode)

        self.action_name = None
        self.dir_from = None
        self.dir_to = None
        self.duration_ms = None
        self.job_uid = None
        self.simulation_uid = None
        self.size_mb = None
        self.throughput_mb_s = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.action_name = ctx.content['actionName']
    ctx.dir_from = ctx.content['dirFrom']
    ctx.dir_to = ctx.content['dirTo']
    ctx.duration_ms = ctx.content['duration_ms']
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']
    ctx.size_mb = ctx.content['size_Mo']
    ctx.throughput_mb_s = ctx.content['throughput_Mo_s']


def _persist_metrics(ctx):
    """Persists metrics info to db.

    """
    db.dao_monitoring.persist_environment_metric(
        ctx.action_name,
        ctx.msg.timestamp,
        ctx.dir_from,
        ctx.dir_to,
        ctx.duration_ms,
        ctx.job_uid,
        ctx.simulation_uid,
        ctx.size_mb,
        ctx.throughput_mb_s
        )
