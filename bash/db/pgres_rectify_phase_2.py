# -*- coding: utf-8 -*-

"""
.. module:: monitoring_job_end.py
   :copyright: Copyright "Mar 21, 2015", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring job end messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>

"""
import argparse

import pika

from hermes_jobs.mq.monitoring import simulation_delete
from hermes_jobs.mq.utils import invoke as invoke_handler
from prodiguer import cv
from prodiguer.db import pgres as db
from prodiguer.db.pgres import dao_mq
from prodiguer.utils import logger



# Map of message types to processing agents.
_AGENTS = {
    u"8888": simulation_delete,
}


def _get_message():
    """Returns a message that previously failed.

    """
    m = db.types.Message

    qry = db.session.query(m)
    qry = qry.filter(m.is_queued_for_reprocessing == True)

    return qry.first()


def _reprocess_message(m, verbose):
    """Reprocesses a message.

    """
    if verbose:
        logger.log_mq("reprocessing message: {} --> {}".format(m.type_id, m.uid))

    # Set message agent.
    if m.type_id not in _AGENTS:
        raise KeyError("Unsupported message re-processing agent: {}".format(m.type_id))
    agent = _AGENTS[m.type_id]

    # Set message AMPQ properties.
    props = pika.BasicProperties(
        app_id=m.app_id,
        content_type=m.content_type,
        content_encoding=m.content_encoding,
        headers={
            'producer_id': m.producer_id
        },
        message_id=m.uid,
        type=m.type_id,
        user_id=m.user_id
        )

    # Set processing context information.
    ctx = agent.ProcessingContextInfo(props, m.content, validate_props=False)
    ctx.msg = m

    # Invoke processing tasks.
    for task in agent.get_tasks():
        task(ctx)
        if ctx.abort:
            break


def _main(throttle):
    """Main entry point.

    """
    # Initialise cv session.
    cv.session.init()

    # Re-process messages.
    reprocessed = 0
    while True if throttle == 0 else reprocessed < throttle:
        with db.session.create():
            # Dequeue next message to be re-processed.
            m = _get_message()
            if m is None:
                logger.log_mq("no more messages to reprocess")
                return

            logger.log_mq("rerpocessing message: {} :: {}".format(m.uid, m.correlation_id_1))

            # Perform message processing.
            try:
                _reprocess_message(m, throttle > 0)
            except Exception as err:
                err = "{} --> {}".format(err.__class__.__name__, err)
                logger.log_mq_error(err)
                db.session.rollback()
                m.processing_error = unicode(err)
            else:
                logger.log_mq("message reprocessed: {} :: {}".format(m.uid, m.correlation_id_1))
                m.processing_error = None
            finally:
                m.processing_tries += 1
                m.is_queued_for_reprocessing = False
                db.session.update(m)

            # Increment counter.
            reprocessed += 1


# Main entry point.
if __name__ == '__main__':
    args = argparse.ArgumentParser("Rectifies message processing errors.")
    args.add_argument(
        "-t", "--throttle",
        help="Limit upon number of message to re-process.",
        dest="throttle",
        type=int,
        default=0
        )
    args = args.parse_args()

    _main(args.throttle)
