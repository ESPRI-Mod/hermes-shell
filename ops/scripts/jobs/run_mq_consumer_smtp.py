# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_persist.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from MQ server and persists them to db.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, imaplib, json, sys

import pika

from prodiguer import config, convert, mq, rt



# MQ exchange to pull from.
_MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_EXT

# MQ queue to pull to.
_MQ_QUEUE = mq.constants.QUEUE_EXT_SMTP

# MQ exchange to push to.
_MQ_EXCHANGE_INTERNAL = mq.constants.EXCHANGE_PRODIGUER_INTERNAL



class _ProcessingContext(object):
    """Encapsulates message processing contextual information."""
    def __init__(self, properties, content):
        """Constructor."""
        self.properties = properties
        self.content = convert.json_to_namedtuple(content)

        self.cfg = config.mq.smtp_bridge
        self.count_parsed = 0
        self.count_read = 0
        self.imap_client = None
        self.email_uid = self.content.email_uid
        self.messages = []
        self.message_errors = []

def _init_imap_client(ctx):
    """Initializes imap client used to communicate with email server."""
    client = imaplib.IMAP4_SSL(host=ctx.cfg.host,
                               port=int(ctx.cfg.port))
    client.login(ctx.cfg.username, ctx.cfg.password)
    ctx.imap_client = client

    # Set mailbox to select from.
    mailbox = ctx.cfg.mailbox
    typ, data = ctx.imap_client.select(mailbox, readonly=True)


def _init_messages(ctx):
    """Initializes set of messages to be dispatched."""
    # Pull email from mail server.
    typ, data = ctx.imap_client.fetch(ctx.email_uid, \
                                      '(BODY.PEEK[TEXT])')
    if typ != 'OK':
        raise Exception("Email retrieval error.")

    # Set email body.
    for response in (i for i in data if isinstance(i, tuple)):
        uid = response[0].split(" ")[0]
        if ctx.email_uid == uid:
            ctx.messages = response[1].split("\n")
            break

    ctx.count_read = len(ctx.messages)
    rt.log_mq("Email contains {0} messages".format(ctx.count_read))


def _release_smtp_connection(ctx):
    """Closes Performs clean up after mail server resources have been processed."""
    ctx.imap_client.close()
    ctx.imap_client.logout()


def _parse_payload(ctx):
    """Parses set of messages to be dispatched."""
    def decode_base64(msg):
        """Performs base64 decoding of message content."""
        try:
            return base64.b64decode(msg)
        except TypeError as err:
            raise Exception("Base64 decoding error:\n{0}".format(msg))

    def encode_json(msg):
        """Performs json encoding of message content."""
        try:
            return json.loads(msg)
        except ValueError as err:
            raise Exception("json encoding error:\n{0}".format(msg))

    def _parse_messages(messages):
        """Parses set of messages embedded in an email."""
        for msg in messages:
            if not len(msg.strip()):
                continue
            try:
                yield encode_json(decode_base64(msg))
            except Exception as err:
                rt.log_mq_error(err)

    ctx.messages = list(_parse_messages(ctx.messages))
    ctx.count_parsed = len(ctx.messages)

    print "{0} messages were parseable.".format(ctx.count_parsed)


def _set_messages(ctx):
    """Sets messages to be dispatched to MQ server."""
    def _get_props(type_id, timestamp):
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = type_id,
            mode = mq.constants.MODE_TEST,
            timestamp = convert.date_to_timestamp(timestamp))

    def prepare(payload):
        """Returns a message prepared for dispatch."""
        props = _get_props(payload['code'], payload['timestamp'])

        return mq.utils.Message(props,
                                payload,
                                mq.constants.EXCHANGE_PRODIGUER_IN)

    ctx.messages = (prepare(msg) for msg in ctx.messages)


def _dispatch(ctx):
    """Dispatches messages to MQ server."""
    def yield_messages():
        """Yields messages for dispatch."""
        for index, msg in enumerate(ctx.messages):
            yield msg

    mq.utils.publish(yield_messages,
                     connection_url=config.mq.connections.libligcm)


def _message_handler(properties, content):
    """Message handler callback."""
    ctx = _ProcessingContext(properties, content)
    for func in (
        _init_imap_client,
        _init_messages,
        _release_smtp_connection,
        _parse_payload,
        _set_messages,
        _dispatch):
        func(ctx)


def _main(consume_limit):
    """Main entry point handler."""
    mq.utils.consume(_MQ_EXCHANGE,
                     _MQ_QUEUE,
                     callback=_message_handler,
                     consume_limit=consume_limit,
                     verbose=consume_limit > 0)


# Main entry point.
if __name__ == "__main__":
    _main(0 if len(sys.argv) <= 1 else int(sys.argv[1]))
