# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0000 messages.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import datetime

from prodiguer import convert, db, mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0000


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.simulation = None
        self.activity = None
        self.execution_state = db.constants.EXECUTION_STATE_QUEUED
        self.execution_start_date = datetime.datetime.now()
        self.experiment = None
        self.space = None
        self.model = None
        self.name = None
        self.compute_node = None
        self.compute_node_login = None
        self.compute_node_machine = None


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _set_simulation_info,
        _persist_simulation,
        _notify_api,
        )


def _get_name(entity_type, entity_id):
    """Utility function to map a db entity id to an entity name."""
    return db.cache.get_name(entity_type, entity_id)


def _set_simulation_info(ctx):
    """Sets simulation information."""
    print "TODO execution start date from timestamp"
    print "TODO correct CMIP6 typo"
    sim_id = ctx.content['simuid'].split(".")
    ctx.activity = sim_id[0]
    ctx.compute_node = sim_id[6]
    ctx.compute_node_login = sim_id[5]
    ctx.compute_node_machine = "{0} - {1}".format(sim_id[6], sim_id[7])
    ctx.experiment = sim_id[2]
    ctx.model = sim_id[4]
    ctx.name = ctx.content['simuid']
    ctx.space = sim_id[3]


def _persist_simulation(ctx):
    """Persists simulation information to db."""
    ctx.simulation = db.mq_hooks.create_simulation(
        ctx.activity,
        ctx.compute_node,
        ctx.compute_node_login,
        ctx.compute_node_machine,
        ctx.execution_start_date,
        ctx.execution_state,
        ctx.experiment,
        ctx.model,
        ctx.name,
        ctx.space
        )


def _notify_api(ctx):
    """Notifies web service API."""
    # Set body of message to be dispatched to API message queue.
    event_info = db.types.Convertor.to_dict(ctx.simulation, True)
    event_info.update({
        u"event_type": "new_simulation",
        u"activity": _get_name(db.types.Activity,
                               ctx.simulation.activity_id),
        u"compute_node": _get_name(db.types.ComputeNode,
                                   ctx.simulation.compute_node_id),
        u"compute_node_login": _get_name(db.types.ComputeNodeLogin,
                                         ctx.simulation.compute_node_login_id),
        u"compute_node_machine": _get_name(db.types.ComputeNodeMachine,
                                           ctx.simulation.compute_node_machine_id),
        u"execution_state": _get_name(db.types.SimulationState,
                                      ctx.simulation.execution_state_id),
        u"experiment": _get_name(db.types.Experiment,
                                 ctx.simulation.experiment_id),
        u"model": _get_name(db.types.Model,
                            ctx.simulation.model_id),
        u"space": _get_name(db.types.SimulationSpace,
                            ctx.simulation.space_id)
        })

    utils.notify_api(event_info)
