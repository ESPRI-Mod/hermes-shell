# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0100 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>

"""
from prodiguer import mq
from prodiguer.db import pgres as db

import utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0100


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message_content,
        _persist_simulation_updates,
        _notify_api
    )


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(props, body, decode=decode)

        self.simulation = None
        self.simulation_uid = None


def _unpack_message_content(ctx):
    """Unpacks message being processed.

    """
    ctx.simulation_uid = ctx.content['simuid']


def _persist_simulation_updates(ctx):
    """Persists simulation updates to db.

    """
    simulation = db.dao_monitoring.retrieve_simulation(ctx.simulation_uid)
    if not simulation:
        ctx.abort = True
    else:
        simulation.execution_end_date = ctx.msg.timestamp
        db.session.update(simulation)


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": u"simulation_complete",
        "simulation_uid": unicode(ctx.simulation_uid)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)
