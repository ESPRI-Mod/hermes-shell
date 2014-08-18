# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_persist.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from MQ server and persists them to db.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import sys

import pika

from prodiguer import config, convert, db, mq



# MQ exchange to consume from.
_MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to consume to.
_MQ_QUEUE = mq.constants.QUEUE_IN_PERSIST

# MQ exchange to produce to.
_MQ_EXCHANGE_INTERNAL = mq.constants.EXCHANGE_PRODIGUER_INTERNAL




class _ProcessingContext(object):
    """Processing context information wrapper."""
    def __init__(self, properties, content):
        """Constructor."""
        self.properties = properties
        self.content = content
        self.msg = None


def _persist(ctx):
    """Persists message to backend db."""
    # TODO: timestamp
    # TODO: determine if other properties should be persisted
    # TODO: persist message mode ?
    # TODO: persist message user-id ?

    # print ctx.properties

    ctx.msg = db.mq_hooks.create_message(
        ctx.properties.message_id,
        ctx.properties.app_id,
        ctx.properties.headers['producer_id'],
        ctx.properties.type,
        ctx.content,
        ctx.properties.content_encoding,
        ctx.properties.content_type)


def _requeue(ctx):
    """Places message on internal queues for further processing."""
    # Create message AMPQ properties.
    props = mq.utils.create_ampq_message_properties(
        user_id = mq.constants.USER_PRODIGUER,
        producer_id = mq.constants.PRODUCER_PRODIGUER,
        app_id = ctx.properties.app_id,
        message_type = ctx.properties.type,
        content_encoding=ctx.properties.content_encoding,
        content_type=ctx.properties.content_type,
        headers={
            'db_id': ctx.msg.id
        },
        message_id = ctx.properties.message_id,
        mode = ctx.properties.headers['mode'],
        timestamp = convert.now_to_timestamp())

    # Create message to be dispatched.
    msg = mq.utils.Message(props,
                           convert.json_to_dict(ctx.content),
                           _MQ_EXCHANGE_INTERNAL)

    # Dispatch message to internal queue(s).
    mq.utils.produce(msg)


def _message_handler(properties, content):
    """Message handler callback."""
    ctx = _ProcessingContext(properties, content)
    for func in (_persist, _requeue):
        func(ctx)


def _main(consume_limit):
    """Main entry point handler."""
    # Start session.
    db.session.start(config.db.connections.main)

    # Initialise cache.
    db.cache.load()

    # Consume messages.
    mq.utils.consume(_MQ_EXCHANGE,
                     _MQ_QUEUE,
                     callback=_message_handler,
                     consume_limit=consume_limit,
                     verbose=consume_limit > 0)

    # Start session.
    db.session.end()


# Main entry point.
if __name__ == "__main__":
    _main(0 if len(sys.argv) <= 1 else int(sys.argv[1]))
