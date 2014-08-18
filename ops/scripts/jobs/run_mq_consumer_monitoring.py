# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_monitoring.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls monitoring specific cmessages from MQ server and performs various tasks.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import sys

import pika

from prodiguer import config, convert, db, mq



# MQ exchange to consume from.
_MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to consume from.
_MQ_QUEUE = mq.constants.QUEUE_INTERNAL_MONITORING



class _ProcessingContext(object):
    """Processing context information wrapper."""
    def __init__(self, properties, content):
        self.properties = properties
        self.content_raw = content
        self.content = convert.json_to_namedtuple(content)

        print self.content.simuid.split(".")

        # Seems like there is some reformatting done
        print self.content_raw
        print self.content
        # self.sim_id = self.content.simuid.split(".")

        # print self.sim_id



def _process_0000(ctx):
    print "Processing message type = 0000"
    print "TODO create new simulation record in db"
    print "TODO inform API"
    print type(ctx.content)
    return


    # Persist simulation to db.
    s = db.mq_hooks.create_simulation(
        ei['activity'],
        ei['compute_node'],
        ei['compute_node_login'],
        ei['compute_node_machine'],
        ei['execution_start_date'],
        ei['execution_state'],
        ei['experiment'],
        ei['model'],
        ei['name'],
        ei['space']
        )


def _process_2000(ctx):
    print "Processing message type = 2000"


def _process_3000(ctx):
    print "Processing message type = 3000"


# Message handlers by message type.
_HANDLERS = {
    "0000": _process_0000,
    "2000": _process_2000,
    "3000": _process_3000
}


def _message_handler(properties, content):
    """Message handler callback."""
    if properties.type in _HANDLERS:
        ctx = _ProcessingContext(properties, content)
        _HANDLERS[properties.type](ctx)


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
