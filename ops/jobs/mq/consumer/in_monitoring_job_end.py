# -*- coding: utf-8 -*-

"""
.. module:: in_monitoring_job_end.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring job end messages.

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


def _persist_job_updates(ctx):
    """Persists job updates to dB.

    """
    dao.persist_job_02(
        ctx.msg.timestamp,
        False,
        ctx.job_uid,
        ctx.simulation_uid
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    # Skip if simulation messages have not yet been received.
    simulation = dao.retrieve_simulation(ctx.simulation_uid)
    if simulation is None:
        return

    # Skip if simulation is obsolete (i.e. it was restarted).
    if simulation.is_obsolete:
        return

    # Enqueue API notification.
    utils.enqueue(mq.constants.TYPE_GENERAL_API, {
        "event_type": u"job_complete",
        "job_uid": unicode(ctx.job_uid),
        "simulation_uid": unicode(ctx.simulation_uid)
    })
