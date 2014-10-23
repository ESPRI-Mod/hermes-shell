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

import arrow
from prodiguer import db, mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0000



def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message,
        _persist_simulation,
        _persist_simulation_state,
        _dispatch_notifications
        )


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(Message, self).__init__(props, body, decode=decode)

        self.simulation = None
        self.activity = None
        self.compute_node = None
        self.compute_node_login = None
        self.compute_node_machine = None
        self.execution_state = db.constants.EXECUTION_STATE_QUEUED
        self.execution_start_date = datetime.datetime.now()
        self.experiment = None
        self.simulation_info = None
        self.space = None
        self.model = None
        self.name = None
        self.output_start_date = None
        self.output_end_date = None
        self.uid = None


def _unpack_message(ctx):
    """Unpacks message being processed.

    """
    ctx.activity = ctx.content['activity']
    ctx.compute_node = ctx.content['centre']
    ctx.compute_node_login = ctx.content['login']
    ctx.compute_node_machine = "{0} - {1}".format(ctx.compute_node, ctx.content['machine'])
    ctx.execution_start_date = utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.execution_state_timestamp = utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.experiment = ctx.content['experiment']
    ctx.model = ctx.content['model']
    ctx.name = ctx.content['name']
    ctx.output_start_date = arrow.get(ctx.content['startDate']).datetime
    ctx.output_end_date = arrow.get(ctx.content['endDate']).datetime
    ctx.space = ctx.content['space']
    ctx.uid = ctx.content['simuid']


def _persist_simulation(ctx):
    """Persists simulation information to db.

    """
    ctx.simulation = mq.db_hooks.create_simulation(
        ctx.activity,
        ctx.compute_node,
        ctx.compute_node_login,
        ctx.compute_node_machine,
        ctx.execution_start_date,
        ctx.execution_state,
        ctx.experiment,
        ctx.model,
        ctx.name,
        ctx.output_start_date,
        ctx.output_end_date,
        ctx.space,
        ctx.uid
        )


def _persist_simulation_state(ctx):
    """Persists simulation state to db.

    """
    mq.db_hooks.create_simulation_state(
        ctx.uid,
        db.constants.EXECUTION_STATE_QUEUED,
        ctx.execution_state_timestamp,
        MQ_QUEUE
        )


def _dispatch_notifications(ctx):
    """Dispatches notifications to various internal services.

    """
    # Set notification data.
    data = db.types.Convertor.to_dict(ctx.simulation, True)
    data.update({
        u"event_type": "new_simulation",
        u"activity": utils.get_name(db.types.Activity,
                                    ctx.simulation.activity_id),
        u"compute_node": utils.get_name(db.types.ComputeNode,
                                        ctx.simulation.compute_node_id),
        u"compute_node_login": utils.get_name(db.types.ComputeNodeLogin,
                                              ctx.simulation.compute_node_login_id),
        u"compute_node_machine": utils.get_name(db.types.ComputeNodeMachine,
                                                ctx.simulation.compute_node_machine_id),
        u"execution_state": utils.get_name(db.types.SimulationState,
                                           ctx.simulation.execution_state_id),
        u"experiment": utils.get_name(db.types.Experiment,
                                      ctx.simulation.experiment_id),
        u"model": utils.get_name(db.types.Model,
                                 ctx.simulation.model_id),
        u"space": utils.get_name(db.types.SimulationSpace,
                                 ctx.simulation.space_id)
        })

    # Dispatch notifications.
    utils.notify_api(data)
    utils.notify_operator("monitoring-0000", data)
