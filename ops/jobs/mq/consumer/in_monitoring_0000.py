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
    """Returns set of tasks to be executed when processing a message."""
    return (
        _unpack_content,
        _validate_content,
        _persist_simulation,
        _set_simulation_info,
        _notify_api,
        _notify_operator
        )


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body, decode=True):
        """Constructor."""
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


def _get_name(entity_type, entity_id):
    """Utility function to map a db entity id to an entity name."""
    return db.cache.get_name(entity_type, entity_id)


def _get_timestamp(timestamp):
    """Returns formatted timestamp for insertion into db.

    This is necessary due to nano-second to second precision errors.

    """
    try:
        return arrow.get(timestamp).datetime
    except arrow.parser.ParserError:
        part1 = timestamp.split(".")[0]
        part2 = timestamp.split(".")[1].split("+")[0][0:6]
        part3 = timestamp.split(".")[1].split("+")[1]
        timestamp = "{0}.{1}+{2}".format(part1, part2, part3)

        return arrow.get(timestamp).to('Europe/Paris').datetime


def _unpack_content(ctx):
    """Unpacks information from message content."""
    ctx.activity = ctx.content['activity']
    ctx.compute_node = ctx.content['centre']
    ctx.compute_node_login = ctx.content['login']
    ctx.compute_node_machine = "{0} - {1}".format(ctx.compute_node, ctx.content['machine'])
    ctx.execution_start_date = _get_timestamp(ctx.props.headers['timestamp'])
    ctx.experiment = ctx.content['experiment']
    ctx.model = ctx.content['model']
    ctx.name = ctx.content['name']
    ctx.output_start_date = arrow.get(ctx.content['startDate']).datetime
    ctx.output_end_date = arrow.get(ctx.content['endDate']).datetime
    ctx.space = ctx.content['space']
    ctx.uid = ctx.content['simuid']


def _validate_content(ctx):
    """Validates information from message content."""
    # TODO


def _persist_simulation(ctx):
    """Persists simulation information to db."""
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


def _set_simulation_info(ctx):
    """Sets simulation information to be used by notifiers."""
    ctx.simulation_info = db.types.Convertor.to_dict(ctx.simulation, True)
    ctx.simulation_info.update({
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


def _notify_api(ctx):
    """Notifies web service API."""
    data = {
        u"event_type": "new_simulation"
    }
    data.update(ctx.simulation_info)

    utils.notify_api(data)


def _notify_operator(ctx):
    """Notifies an operator that simulation has completed."""
    utils.notify_operator(ctx, "monitoring-0000")
