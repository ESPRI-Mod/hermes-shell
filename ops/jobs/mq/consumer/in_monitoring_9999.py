# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_9999.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 9999 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq
from prodiguer.db.pgres import dao_monitoring as dao

import utils



def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message_content,
        _persist_simulation_updates,
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
        self.simulation = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']


def _persist_simulation_updates(ctx):
    """Persists simulation updates to dB.

    """
    ctx.simulation = dao.persist_simulation_02(
        ctx.msg.timestamp,
        True,
        ctx.simulation_uid
        )


def _persist_job(ctx):
    """Persists job info to dB.

    """
    dao.persist_job_02(
        ctx.msg.timestamp,
        True,
        ctx.job_uid,
        ctx.simulation_uid
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    # Skip if the 0000 message has not yet been received.
    if ctx.simulation.hashid is None:
        return

    # Skip if not the active simulation.
    active_simulation = dao.retrieve_active_simulation(ctx.simulation.hashid)
    if ctx.simulation.uid != active_simulation.uid:
        return

    # Enqueue API notification.
    utils.enqueue(mq.constants.TYPE_GENERAL_API, {
        "event_type": u"simulation_error",
        "simulation_uid": unicode(ctx.simulation_uid)
    })
