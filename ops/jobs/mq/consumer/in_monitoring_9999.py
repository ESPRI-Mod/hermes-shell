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
from prodiguer.db import pgres as db

import utils



def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message_content,
        _persist_simulation_updates,
        _persist_job,
        _set_active_simulation,
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

        self.active_simulation = None
        self.job_uid = None
        self.simulation = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.job_uid = ctx.content['jobuid']
    ctx.simulation_uid = ctx.content['simuid']


def _persist_simulation_updates(ctx):
    """Persists simulation updates to db.

    """
    ctx.simulation = db.dao_monitoring.persist_simulation_02(
        ctx.msg.timestamp,
        True,
        ctx.simulation_uid
        )


def _persist_job(ctx):
    """Persists job info to db.

    """
    db.dao_monitoring.persist_job_02(
        ctx.msg.timestamp,
        True,
        ctx.job_uid,
        ctx.simulation_uid
        )


def _set_active_simulation(ctx):
    """Sets the so-called active simulation.

    """
    # Skip if the 0000 message has not yet been received.
    if ctx.simulation.hashid is None:
        return

    ctx.active_simulation = \
        db.dao_monitoring.retrieve_active_simulation(ctx.simulation.hashid)


def _notify_api(ctx):
    """Dispatches API notification.

    """
    # Skip if the 0000 message has not yet been received.
    if ctx.simulation.hashid is None:
        return
    # Skip if not the active simulation.
    if ctx.simulation.uid != ctx.active_simulation.uid:
        return

    data = {
        "event_type": u"simulation_error",
        "simulation_uid": unicode(ctx.simulation_uid)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)

