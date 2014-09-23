# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_persist.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from MQ server and persists them to db.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, imaplib, json

import numpy as np

from prodiguer import config, convert, mq, rt



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_EXT

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_EXT_SMTP


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)
        self.cfg = config.mq.smtp_bridge
        self.count_parsed = 0
        self.count_read = 0
        self.email_uid = self.content['email_uid']
        self.imap_client = None
        self.messages = []
        self.message_errors = []


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _init_imap_client,
        _init_messages,
        _release_smtp_connection,
        _parse_payload,
        _format_timestamp,
        _dispatch,
        _log_stats
        )


def get_error_tasks():
    """Returns set of tasks to be executed when a message processing error occurs."""
    return None


def _get_timestamp(timestamp):
    """Returns a formatted timestamp."""
    stamp = np.datetime64(timestamp, dtype="datetime64[ns]")

    return stamp.astype(long)


def _init_imap_client(ctx):
    """Initializes imap client used to communicate with email server."""
    # Login to mail server.
    client = imaplib.IMAP4_SSL(host=ctx.cfg.host,
                               port=int(ctx.cfg.port))
    client.login(ctx.cfg.username, ctx.cfg.password)
    ctx.imap_client = client

    # Set mailbox.
    ctx.imap_client.select(ctx.cfg.mailbox, readonly=True)


def _init_messages(ctx):
    """Initializes set of messages to be dispatched."""
    # Pull email from mail server.
    typ, data = ctx.imap_client.fetch(ctx.email_uid, '(BODY.PEEK[TEXT])')
    if typ != 'OK':
        raise Exception("Email retrieval error.")

    # Set email body.
    for response in (i for i in data if isinstance(i, tuple)):
        uid = response[0].split(" ")[0]
        if ctx.email_uid == uid:
            ctx.messages = response[1].split("\n")
            break

    ctx.messages = [m.strip() for m in ctx.messages if m and m.strip()]
    ctx.count_read = len(ctx.messages)


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
            try:
                yield encode_json(decode_base64(msg))
            except Exception as err:
                yield err

    parsed = list(_parse_messages(ctx.messages))
    ctx.message_errors = [m for m in parsed if isinstance(m, Exception)]
    ctx.messages = [m for m in parsed if not isinstance(m, Exception)]
    ctx.count_parsed = len(ctx.messages)


def _format_timestamp(ctx):
    """Formats message timestamps."""
    for msg in ctx.messages:
        msg['msgTimestamp'] = "{0}T{1}.{2}".format(msg['msgTimestamp'][0:10],
                                                   msg['msgTimestamp'][11:19],
                                                   msg['msgTimestamp'][20:])


def _dispatch(ctx):
    """Dispatches messages to MQ server."""
    def _get_msg_props(body):
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_id = msg.content['msgUID'],
            message_type = body['msgCode'],
            mode = mq.constants.MODE_TEST,
            timestamp = _get_timestamp(body['msgTimestamp']))

    def _get_messages():
        """Dispatch message source."""
        for body in ctx.messages:
            yield mq.Message(_get_msg_props(body),
                             body,
                             mq.constants.EXCHANGE_PRODIGUER_IN)

    mq.produce(_get_messages,
               connection_url=config.mq.connections.libigcm)


def _log_stats(ctx):
    """Logs processing statistics."""
    rt.log_mq("Email contained {0} messages".format(ctx.count_read))
    rt.log_mq("{0} messages were parseable.".format(ctx.count_parsed))
    rt.log_mq("{0} parsing errors .".format(len(ctx.message_errors)))
