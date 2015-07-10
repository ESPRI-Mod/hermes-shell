# -*- coding: utf-8 -*-

"""
.. module:: in_monitoring_job_start.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring job start messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv
from prodiguer import mq
from prodiguer.db import pgres as db
from prodiguer.utils import config

import utils



def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return [
        _drop_obsoletes,
        _unpack_message_content,
        _persist_job,
        _persist_simulation_updates,
        _notify_api
    ]


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(
            props, body, decode=decode)

        self.accounting_project = None
        self.job_type = None
        self.job_uid = None
        self.job_warning_delay = None
        self.simulation_uid = None


def _drop_obsoletes(ctx):
    """Drops messages considered obsolete.

    """
    # If the field 'command' exists then this was
    # from a version of libIGCM now considered obsolete.
    if "command" in ctx.content:
        ctx.abort = True


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.accounting_project = ctx.content.get('accountingProject')
    ctx.job_uid = ctx.content['jobuid']
    ctx.job_warning_delay = ctx.content.get(
        'jobWarningDelay', config.apps.monitoring.defaultJobWarningDelayInSeconds)
    ctx.simulation_uid = ctx.content['simuid']


def _persist_job(ctx):
    """Persists job info to db.

    """
    db.dao_monitoring.persist_job_01(
        ctx.accounting_project,
        ctx.job_warning_delay,
        ctx.msg.timestamp,
        ctx.job_type,
        ctx.job_uid,
        ctx.simulation_uid
        )


def _persist_simulation_updates(ctx):
    """Updates simulation (compute jobs only)

    """
    # Skip if not processing a compute job.
    if ctx.job_type != cv.constants.JOB_TYPE_COMPUTING:
        return

    # Ensure simulation is not considered to be in an error state.
    db.dao_monitoring.persist_simulation_02(
        None,
        False,
        ctx.simulation_uid
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    # Skip if simulation start (000) message not received.
    simulation = db.dao_monitoring.retrieve_simulation(ctx.simulation_uid)
    if simulation is None:
        return

    # Skip if simulation is obsolete (i.e. it was restarted).
    if simulation.is_obsolete:
        return

    # Enqueue API notification.
    utils.enqueue(mq.constants.TYPE_GENERAL_API, {
        "event_type": u"job_start",
        "job_uid": unicode(ctx.job_uid),
        "simulation_uid": unicode(ctx.simulation_uid)
        })
