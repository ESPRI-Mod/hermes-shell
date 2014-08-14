# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_persist.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from MQ server and persists them to db.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import pika

from prodiguer import config, db, mq



# MQ exchange to bind to.
_MQ_EXCHANGE = 'x-in'

# MQ queue to bind to.
_MQ_QUEUE = 'q-in-persist'






def _persist(properties, content):
    # TODO: timestamp
    # TODO: determine if other properties should be persisted
    # TODO: persist message mode ?
    # TODO: persist message user-id ?

    # print properties

    db.mq_hooks.create_message(
        properties.message_id,
        properties.app_id,
        properties.headers['producer_id'],
        properties.type,
        content,
        properties.content_encoding,
        properties.content_type)


def _requeue(properties, content):
    # TODO: place on internal queue for further processing
    pass

def _message_handler(properties, content):
    # TODO: exception handler
    try:
        _persist(properties, content)
        _requeue(properties, content)
    except Exception as err:
        print err


def _main():
    """Main entry point handler."""
    # Start session.
    db.session.start(config.db.connections.main)

    # Initialise cache.
    db.cache.load()

    # Consume messages.
    mq.utils.consume(_MQ_EXCHANGE,
                     _MQ_QUEUE,
                     callback=_message_handler,
                     consume_limit=0)

    # Start session.
    db.session.end()


# Main entry point.
if __name__ == "__main__":
    _main()
