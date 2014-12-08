# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import datetime

import arrow
import sqlalchemy
from prodiguer import db, mq, cv, rt

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_0000



def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _unpack_message_content,
        _reformat_message_content,
        _parse_cv_terms,
        _persist_cv_terms,
        _persist_simulation,
        _persist_simulation_state,
        _notify_api,
        _notify_operator
        )


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(props, body, decode=decode)

        self.activity = None
        self.compute_node = None
        self.compute_node_login = None
        self.compute_node_machine = None
        self.new_cv_terms = []
        self.execution_state = db.constants.EXECUTION_STATE_QUEUED
        self.execution_start_date = datetime.datetime.now()
        self.experiment = None
        self.simulation_space = None
        self.model = None
        self.name = None
        self.output_start_date = None
        self.output_end_date = None
        self.uid = None


    @property
    def cv_fields(self):
        """Gets set of cv related fields.

        """
        return [
            'activity',
            'compute_node',
            'compute_node_login',
            'compute_node_machine',
            'experiment',
            'model',
            'simulation_space'
        ]

    @property
    def lower_case_fields(self):
        """Gets set of fields to be formatted in lower case.

        """
        return [
            'activity',
            'compute_node',
            'compute_node_machine',
            'model',
            'simulation_space'
        ]


def _unpack_message_content(ctx):
    """Unpacks message content prior to further processing.

    """
    ctx.activity = ctx.content['activity']
    ctx.compute_node = ctx.content['centre']
    ctx.compute_node_login = ctx.content['login']
    ctx.compute_node_machine = \
        "{0}-{1}".format(ctx.compute_node, ctx.content['machine'])
    ctx.execution_start_date = \
        utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.execution_state_timestamp = \
        utils.get_timestamp(ctx.props.headers['timestamp'])
    ctx.experiment = ctx.content['experiment']
    ctx.model = ctx.content['model']
    ctx.name = ctx.content['name']
    ctx.output_start_date = arrow.get(ctx.content['startDate']).datetime
    ctx.output_end_date = arrow.get(ctx.content['endDate']).datetime
    ctx.simulation_space = ctx.content['space']
    ctx.uid = ctx.content['simuid']


def _reformat_message_content(ctx):
    """Reformats unpacked message content prior to further processing.

    """
    for field in ctx.lower_case_fields:
        setattr(ctx, field, getattr(ctx, field).lower())


def _parse_cv_terms(ctx):
    """Parses cv terms contained within message content.

    """
    for field in ctx.cv_fields:
        existing = getattr(ctx, field)
        try:
            parsed = cv.parse(field, existing)
        except ValueError:
            ctx.new_cv_terms.append((field, existing))
        else:
            if existing != parsed:
                setattr(ctx, field, parsed)
                msg = "CV term subsitution: {0}.{1} --> {0}.{2}"
                msg = msg.format(field, existing, parsed)
                rt.log_mq(msg)


def _persist_cv_terms(ctx):
    """Persists cv terms to db.

    """
    if not ctx.new_cv_terms:
        return

    # Create new cv terms.
    for term_type, term_name in ctx.new_cv_terms:
        try:
            db.session.insert(cv.create(term_type, term_name))
        except sqlalchemy.exc.IntegrityError:
            db.session.rollback()

    # Reload db cache.
    db.cache.reload()


def _persist_simulation(ctx):
    """Persists simulation information to db.

    """
    mq.db_hooks.create_simulation(
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
        ctx.simulation_space,
        ctx.uid
        )


def _persist_simulation_state(ctx):
    """Persists simulation state to db.

    """
    mq.db_hooks.create_simulation_state(
        ctx.uid,
        ctx.execution_state,
        ctx.execution_state_timestamp,
        MQ_QUEUE
        )


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": "new_simulation",
        "uid": ctx.uid,
        "new_cv_terms": ctx.new_cv_terms
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)


def _notify_operator(ctx):
    """Dispatches operator notification.

    """
    utils.notify_operator(ctx.uid, "monitoring-0000")
