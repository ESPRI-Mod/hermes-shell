# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_log.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Logs all messages received by MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import sys

import pika

from prodiguer import config, convert, db, mq



# MQ exchange to consume from.
_MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to consume to.
_MQ_QUEUE = mq.constants.QUEUE_IN_LOG




def _message_handler(properties, content):
    """Message handler callback."""
    print "TODO: log message: {0}".format(properties.message_id)


def _main(consume_limit):
    """Main entry point handler."""
    # Consume messages.
    mq.utils.consume(_MQ_EXCHANGE,
                     _MQ_QUEUE,
                     callback=_message_handler,
                     consume_limit=consume_limit,
                     verbose=consume_limit > 0)


# Main entry point.
if __name__ == "__main__":
    _main(0 if len(sys.argv) <= 1 else int(sys.argv[1]))
