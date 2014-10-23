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

from prodiguer import config, mail, mq, rt



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_EXT

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_EXT_SMTP


def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _set_email,
        _set_messages_b64,
        _set_messages_json,
        _set_messages_dict,
        _set_messages_ampq,
        _dispatch,
        _log_stats,
        # _delete_email,
        _close_imap_proxy
        )


def get_error_tasks():
    """Returns set of tasks to be executed when a message processing error occurs.

    """
    return _close_imap_proxy


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper.

    """
    def __init__(self, props, body):
        """Object constructor.

        """
        super(Message, self).__init__(props, body, decode=True)

        self.email = None
        self.email_attachment = None
        self.email_uid = self.content['email_uid']
        self.imap_proxy = None
        self.messages = []
        self.messages_b64 = []
        self.messages_json = []
        self.messages_json_error = []
        self.messages_dict = []
        self.messages_dict_error = []


def _get_correlation_id(msg):
    """Returns correlation id from message body.

    """
    # TODO - also jobuid ?
    if 'simuid' in msg:
        return msg['simuid']
    else:
        return None


def _get_msg_props(msg):
    """Returns an AMPQ basic properties instance, i.e. message header.

    """
    # Decode nano-second precise timestamp.
    timestamp = mq.Timestamp.from_ns(msg['msgTimestamp'])

    return mq.utils.create_ampq_message_properties(
        user_id = mq.constants.USER_IGCM,
        producer_id = msg['msgProducer'],
        app_id = msg['msgApplication'],
        correlation_id=_get_correlation_id(msg),
        message_id = msg['msgUID'],
        message_type = msg['msgCode'],
        mode = mq.constants.MODE_TEST,
        timestamp = timestamp.as_ms_int,
        headers = {
            "timestamp": unicode(timestamp.as_ns_raw),
            "timestamp_precision": u'ns'
        })


def _get_msg_payload(msg):
    """Formats message payload.

    """
    # Strip out platform related attributes as these are no longer required.
    return { k: msg[k] for k in msg.keys() if not k.startswith("msg") }


def _decode_b64(data):
    """Helper function: decodes base64 encoded text.

    """
    try:
        return base64.b64decode(data)
    except Exception as err:
        return data, err


def _encode_json(data):
    """Helper function: encodes json encoded text.

    """
    try:
        return json.loads(data)
    except Exception as err:
        try:
            return json.loads(data.replace('\\', ''))
        except Exception as err:
            return data, err


def _set_email(ctx):
    """Initializes email to be processed.

    """
    # Connect to imap server.
    ctx.imap_proxy = mail.get_imap_proxy()

    # Pull email.
    body, attachment = mail.get_email(ctx.email_uid, ctx.imap_proxy)

    # Decode email.
    ctx.email = body.get_payload(decode=True)
    ctx.email_attachment = attachment


def _set_messages_b64(ctx):
    """Sets base64 encoded messages to be processed.

    """
    ctx.messages_b64 += [l for l in ctx.email.splitlines() if l]


def _set_messages_json(ctx):
    """Decode json encoded strings from base64 encoded string.

    """
    for msg in [_decode_b64(m) for m in ctx.messages_b64]:
        if isinstance(msg, tuple):
            ctx.messages_json_error.append(msg)
        else:
            ctx.messages_json.append(msg)


def _set_messages_dict(ctx):
    """Encode json encoded strings to dictionaries.

    """
    for msg in [_encode_json(m) for m in ctx.messages_json]:
        if isinstance(msg, tuple):
            ctx.messages_dict_error.append(msg)
        else:
            ctx.messages_dict.append(msg)


def _set_messages_ampq(ctx):
    """Set AMPQ messages to be dispatched.

    """
    for msg in ctx.messages_dict:
        ctx.messages.append(mq.Message(_get_msg_props(msg),
                                       _get_msg_payload(msg),
                                       mq.constants.EXCHANGE_PRODIGUER_IN))


def _dispatch(ctx):
    """Dispatches messages to MQ server.

    """
    mq.produce(ctx.messages,
               connection_url=config.mq.connections.libigcm)


def _delete_email(ctx):
    """Deletes email as it has already been.

    """
    ctx.imap_proxy.delete_messages(ctx.email_uid)


def _close_imap_proxy(ctx):
    """Closes imap proxy after use.

    """
    mail.close_imap_proxy(ctx.imap_proxy)


def _log_stats(ctx):
    """Logs processing statistics.

    """
    msg = "Email uid: {0};  "
    msg += "Incoming: {1};  "
    msg += "Base64 decoding errors: {2};  "
    msg += "JSON encoding errors: {3};  "
    msg += "Outgoing: {4}."
    msg = msg.format(ctx.email_uid,
                     len(ctx.messages_b64),
                     len(ctx.messages_json_error),
                     len(ctx.messages_dict_error),
                     len(ctx.messages))

    rt.log_mq(msg)
