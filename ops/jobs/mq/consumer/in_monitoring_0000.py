# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_0000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 0000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import arrow
from sqlalchemy.exc import IntegrityError

from prodiguer import cv, mq, rt
from prodiguer.db import pgres as db

import utils



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
        _persist_cv_terms_to_fs,
        _persist_cv_terms_persisted_to_db,
        _persist_simulation,
        _persist_dead_simulation_updates,
        _persist_simulation_configuration,
        _push_cv_terms,
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

        self.abort = False
        self.activity = None
        self.compute_node = None
        self.compute_node_login = None
        self.compute_node_machine = None
        self.configuration = None
        self.cv_terms = []
        self.cv_terms_new = []
        self.cv_terms_persisted_to_db = []
        self.experiment = None
        self.simulation = None
        self.simulation_space = None
        self.model = None
        self.name = None
        self.output_start_date = None
        self.output_end_date = None
        self.simulation_uid = None


    @property
    def cv_term_fields(self):
        """Gets set of cv term related fields.

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
    def cv_term_fields_mixed_case(self):
        """Gets set of mixed case cv term related fields.

        """
        return [
            'experiment'
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
    ctx.configuration = ctx.content.get('configuration')
    ctx.experiment = ctx.content['experiment']
    ctx.model = ctx.content['model']
    ctx.name = ctx.content['name']
    ctx.output_start_date = arrow.get(ctx.content['startDate']).datetime
    ctx.output_end_date = arrow.get(ctx.content['endDate']).datetime
    ctx.simulation_space = ctx.content['space']
    ctx.simulation_uid = ctx.content['simuid']


def _reformat_message_content(ctx):
    """Reformats unpacked message content prior to further processing.

    """
    for field in ctx.lower_case_fields:
        setattr(ctx, field, getattr(ctx, field).lower())


def _parse_cv_terms(ctx):
    """Parses cv terms contained within message content.

    """
    for term_type in ctx.cv_term_fields:
        term_name = getattr(ctx, term_type)
        try:
            cv.validation.validate_term_name(term_type, term_name)

        # New terms.
        except cv.TermNameError:
            ctx.cv_terms_new.append(cv.create(term_type, term_name))

        # Existing terms.
        else:
            parsed_term_name = cv.parser.parse_term_name(term_type, term_name)
            if term_name != parsed_term_name:
                setattr(ctx, term_type, parsed_term_name)
                msg = "CV term subsitution: {0}.{1} --> {0}.{2}"
                msg = msg.format(term_type, term_name, parsed_term_name)
                rt.log_mq(msg)
                term_name = parsed_term_name
            ctx.cv_terms.append(cv.cache.get_term(term_type, term_name))


def _persist_cv_terms_to_fs(ctx):
    """Persists cv terms to file system.

    """
    # Commit cv session.
    cv.session.insert(ctx.cv_terms_new)
    cv.session.commit()

    # Reparse.
    ctx.cv_terms = []
    _parse_cv_terms(ctx)


def _persist_cv_terms_persisted_to_db(ctx):
    """Persists cv terms to database.

    """
    for term in ctx.cv_terms:
        persisted_term = None
        try:
            persisted_term = db.dao_cv.create_term(
                term['meta']['type'],
                term['meta']['name'],
                term['meta'].get('display_name', None)
                )
        except IntegrityError:
            db.session.rollback()
        finally:
            if persisted_term:
                ctx.cv_terms_persisted_to_db.append(persisted_term)


def _persist_simulation(ctx):
    """Persists simulation information to db.

    """
    ctx.simulation = db.dao_monitoring.persist_simulation_01(
        ctx.activity,
        ctx.compute_node,
        ctx.compute_node_login,
        ctx.compute_node_machine,
        ctx.msg.timestamp,
        ctx.experiment,
        ctx.model,
        ctx.name,
        ctx.output_start_date,
        ctx.output_end_date,
        ctx.simulation_space,
        ctx.simulation_uid
        )


def _persist_simulation_configuration(ctx):
    """Persists simulation configuration to db.

    """
    if not ctx.configuration:
        return

    db.dao_monitoring.create_simulation_configuration(
        ctx.simulation_uid,
        ctx.configuration
        )


def _persist_dead_simulation_updates(ctx):
    """Updates previous simulation runs now considered dead.

    """
    db.dao_monitoring.update_dead_simulation_runs(
        ctx.simulation.hashid,
        ctx.simulation_uid
        )
    db.session.commit()


def _push_cv_terms(ctx):
    """Pushes new CV terms to remote GitHub repo.

    """
    if not ctx.cv_terms_persisted_to_db and not ctx.cv_terms_new:
        return

    utils.dispatch_message({}, mq.constants.TYPE_GENERAL_CV)


def _notify_api(ctx):
    """Dispatches API notification.

    """
    data = {
        "event_type": u"simulation_start",
        "simulation_uid": unicode(ctx.simulation_uid),
        "cv_terms": db.utils.get_collection(ctx.cv_terms_persisted_to_db)
    }

    utils.dispatch_message(data, mq.constants.TYPE_GENERAL_API)
