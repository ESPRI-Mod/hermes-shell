# -*- coding: utf-8 -*-

"""
.. module:: run_mq_consumer_persist.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from MQ server and persists them to db.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, json

import numpy as np

from prodiguer import config, email, mq, rt



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_EXT

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_EXT_SMTP


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _set_email,
        _set_messages_b64,
        _set_messages_json,
        _set_messages_dict,
        _set_messages_ampq,
        _dispatch,
        _delete_email,
        _log_stats
        )


def get_error_tasks():
    """Returns set of tasks to be executed when a message processing error occurs."""
    return None


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.email = None
        self.email_uid = self.content['email_uid']
        self.messages = []
        self.messages_b64 = []
        self.messages_json = []
        self.messages_json_error = []
        self.messages_dict = []
        self.messages_dict_error = []


def _get_timestamp(timestamp):
    """Helper function: returns a formatted timestamp."""
    timestamp = np.datetime64(timestamp, dtype="datetime64[ns]")

    return timestamp.astype(long)


def _get_msg_props(msg):
    """Returns an AMPQ basic properties instance, i.e. message header."""
    return mq.utils.create_ampq_message_properties(
        user_id = mq.constants.USER_IGCM,
        producer_id = mq.constants.PRODUCER_IGCM,
        app_id = mq.constants.APP_MONITORING,
        message_id = msg['msgUID'],
        message_type = msg['msgCode'],
        mode = mq.constants.MODE_TEST,
        timestamp = _get_timestamp(msg['msgTimestamp']))


def _decode_b64(data):
    """Helper function: decodes base64 encoded text."""
    try:
        return base64.b64decode(data)
    except Exception as err:
        return data, err


def _encode_json(data):
    """Helper function: encodes json encoded text."""
    try:
        return json.loads(data)
    except Exception as err:
        try:
            return json.loads(data.replace('\\', ''))
        except Exception as err:
            return data, err


def _set_email(ctx):
    """Initializes email to be processed."""
    proxy = email.get_imap_proxy()
    try:
        data = proxy.fetch(ctx.email_uid, ['BODY.PEEK[TEXT]'])
    finally:
        email.close_imap_proxy(proxy)

    # Validate imap response.
    if ctx.email_uid not in data or \
       u'BODY[TEXT]' not in data[ctx.email_uid]:
       raise ValueError("Email {0} not found.".format(ctx.email_uid))

    # Set email payload to be processed.
    ctx.email = data[ctx.email_uid][u'BODY[TEXT]']


def _set_messages_b64(ctx):
    """Sets base64 encoded messages to be processed."""
    ctx.messages_b64 += [l for l in ctx.email.splitlines() if l]


def _set_messages_json(ctx):
    """Decode json encoded strings from base64 encoded string."""
    for msg in [_decode_b64(m) for m in ctx.messages_b64]:
        if isinstance(msg, tuple):
            ctx.messages_json_error.append(msg)
        else:
            ctx.messages_json.append(msg)


def _set_messages_dict(ctx):
    """Encode json encoded strings to dictionaries."""
    for msg in [_encode_json(m) for m in ctx.messages_json]:
        if isinstance(msg, tuple):
            ctx.messages_dict_error.append(msg)
        else:
            ctx.messages_dict.append(msg)


def _set_messages_ampq(ctx):
    """Set AMPQ messages to be dispatched."""
    for msg in ctx.messages_dict:
        ctx.messages.append(mq.Message(_get_msg_props(msg),
                                       msg,
                                       mq.constants.EXCHANGE_PRODIGUER_IN))


def _dispatch(ctx):
    """Dispatches messages to MQ server."""
    mq.produce(ctx.messages,
               connection_url=config.mq.connections.libigcm)


def _delete_email(ctx):
    """Deletes email as it has already been."""
    proxy = email.get_imap_proxy()
    try:
        proxy.delete_messages(ctx.email_uid)
    finally:
        email.close_imap_proxy(proxy)


def _log_stats(ctx):
    """Logs processing statistics."""
    msg = "Incoming: {0};  "
    msg += "Base64 decoding errors: {1};  "
    msg += "JSON encoding errors: {2};  "
    msg = "Outgoing: {3}."
    msg = msg.format(len(ctx.messages_b64), len(ctx.messages_json_error), len(ctx.messages_dict_error), len(ctx.messages))

    rt.log_mq(msg)
