# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Enqueues messages embedded in enqueued emails received from libIGCM.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import base64
import copy
import json
import uuid

from prodiguer import config
from prodiguer import mail
from prodiguer import mq
from prodiguer.db import pgres as db
from prodiguer.utils import logger



# Map of message types to attachment fields.
_ATTACHMENT_FIELD_MAP = {
    '0000': u'configuration',
    '7100': u'metrics'
}

def get_tasks():
    """Returns set of tasks to be executed when processing a message.

    """
    return (
        _set_email,
        _set_messages_b64,
        _set_messages_json,
        _set_messages_dict,
        _drop_excluded_messages,
        _drop_obsolete_messages,
        _process_attachments,
        _set_messages_ampq,
        _dispatch,
        _log_stats,
        _dequeue_email,
        _close_imap_client
        )


def get_error_tasks():
    """Returns set of tasks to be executed when a message processing error occurs.

    """
    return _close_imap_client


class ProcessingContextInfo(mq.Message):
    """Message processing context information.

    """
    def __init__(self, props, body):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(props, body, decode=True)

        self.email = None
        self.email_attachments = None
        self.email_uid = self.content['email_uid']
        self.imap_client = None
        self.messages_ampq = []
        self.messages_ampq_error = []
        self.messages_b64 = []
        self.messages_json = []
        self.messages_json_error = []
        self.messages_dict = []
        self.messages_dict_error = []
        self.messages_dict_excluded = []
        self.messages_dict_obsolete = []


def _set_email(ctx):
    """Initializes email to be processed.

    """
    # Connect to imap server.
    ctx.imap_client = mail.connect()

    # Pull email.
    body, attachments = mail.get_email(ctx.email_uid, ctx.imap_client)

    # Decode email.
    ctx.email = body.get_payload(decode=True)
    ctx.email_attachments = [a.get_payload(decode=True) for a in attachments]


def _set_messages_b64(ctx):
    """Sets base64 encoded messages to be processed.

    """
    ctx.messages_b64 += [l for l in ctx.email.splitlines() if l]


def _set_messages_json(ctx):
    """Decode json encoded strings from base64 encoded string.

    """
    def _decode(data):
        """Decodes base64 encoded text.

        """
        try:
            return base64.b64decode(data)
        except Exception as err:
            return data, err

    for msg in [_decode(m) for m in ctx.messages_b64]:
        if isinstance(msg, tuple):
            ctx.messages_json_error.append(msg)
        else:
            ctx.messages_json.append(msg)


def _set_messages_dict(ctx):
    """Encode json encoded strings to dictionaries.

    """
    def _encode(data):
        """Encodes json encoded text.

        """
        try:
            return json.loads(data)
        except Exception as err:
            try:
                return json.loads(data.replace('\\', ''))
            except Exception as err:
                return data, err

    for msg in [_encode(m) for m in ctx.messages_json]:
        if isinstance(msg, tuple):
            ctx.messages_dict_error.append(msg)
        else:
            ctx.messages_dict.append(msg)


def _drop_excluded_messages(ctx):
    """Drops messages that are excluded due to their type.

    """
    def _is_excluded(msg):
        """Determines whether the message is deemed to be excluded.

        """
        return msg['msgCode'] in config.mq.mail.smtpConsumer.excludedTypes

    ctx.messages_dict_excluded = \
        [m for m in ctx.messages_dict if _is_excluded(m)]
    ctx.messages_dict = \
        [m for m in ctx.messages_dict if m not in ctx.messages_dict_excluded]


def _drop_obsolete_messages(ctx):
    """Drops messages that came from an obsolete source.

    """
    def _is_obsolete(msg):
        """Determines whether the message is deemed to be obsolete.

        """
        # Obsolete if old pop / push stack messages.
        if msg['msgCode'] in ['2000', '3000'] and "command" in msg:
            return True

    ctx.messages_dict_obsolete = \
        [m for m in ctx.messages_dict if _is_obsolete(m)]
    ctx.messages_dict = \
        [m for m in ctx.messages_dict if m not in ctx.messages_dict_obsolete]


def _process_attachments_0000(ctx):
    """Processes email attachments for message type 0000.

    """
    msg = ctx.messages_dict[0]
    msg['configuration'] = ctx.email_attachments[0]


def _process_attachments_7100(ctx):
    """Processes email attachments for message type 7100.

    """
    msg = ctx.messages_dict[0]
    ctx.messages_dict = []
    for attachment in ctx.email_attachments:
        new_msg = copy.deepcopy(msg)
        new_msg['msgUID'] = unicode(uuid.uuid4())
        new_msg['metrics'] = base64.encodestring(attachment)
        ctx.messages_dict.append(new_msg)


# Map of attachment handlers to message types.
_ATTACHMENT_HANDLERS = {
    '0000': _process_attachments_0000,
    '7100': _process_attachments_7100
}


def _process_attachments(ctx):
    """Processes an email attchment.

    """
    # Escape if there are no attachments to process.
    if not ctx.email_attachments:
        return

    # Escape if attachment is not associated with a single message.
    # TODO emit warning
    if len(ctx.messages_dict) != 1:
        return

    # Escape if message type is not mapped to a handler.
    msg = ctx.messages_dict[0]
    if msg['msgCode'] not in _ATTACHMENT_HANDLERS:
        return

    # Invoke handler.
    handler = _ATTACHMENT_HANDLERS[msg['msgCode']]
    handler(ctx)


def _set_messages_ampq(ctx):
    """Set AMPQ messages to be dispatched.

    """
    def _get_ampq_props(data):
        """Returns an AMPQ basic properties instance, i.e. message header.

        """
        # Decode nano-second precise timestamp.
        timestamp = mq.Timestamp.from_ns(data['msgTimestamp'])

        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = data['msgProducer'],
            app_id = data['msgApplication'],
            message_id = data['msgUID'],
            message_type = data['msgCode'],
            timestamp = timestamp.as_ms_int,
            headers = {
                'timestamp': unicode(timestamp.as_ns_raw),
                'timestamp_precision': u'ns',
                'correlation_id_1': data.get('simuid'),
                'correlation_id_2': data.get('jobuid')
            })


    def _get_ampq_payload(data):
        """Return ampq message payload.

        """
        # Strip out non-platform platform attributes.
        return { k: data[k] for k in data.keys() if not k.startswith("msg") }


    def _encode(data):
        """Encodes data as an ampq message.

        """
        try:
            return mq.Message(_get_ampq_props(data),
                              _get_ampq_payload(data),
                              mq.constants.EXCHANGE_PRODIGUER_IN)
        except Exception as err:
            return data, err


    for msg in [_encode(m) for m in ctx.messages_dict]:
        if isinstance(msg, tuple):
            ctx.messages_ampq_error.append(msg)
        else:
            ctx.messages_ampq.append(msg)


def _dispatch(ctx):
    """Dispatches messages to MQ server.

    """
    mq.produce(ctx.messages_ampq,
               connection_url=config.mq.connections.libigcm)


def _dequeue_email(ctx):
    """Removes email from mailbox after processing.

    """
    if config.mq.mail.deleteProcessed:
        mail.delete_email(ctx.email_uid, client=ctx.imap_client)
    else:
        mail.move_email(ctx.email_uid, client=ctx.imap_client)


def _close_imap_client(ctx):
    """Closes imap client after use.

    """
    try:
        mail.disconnect(ctx.imap_client)
    except:
        logger.log_mq_warning("IMAP server disconnection error, error was discarded.")


def _log_stats(ctx):
    """Logs processing statistics.

    """
    msg = "Email uid: {};  ".format(ctx.email_uid)
    msg += "Incoming: {};  ".format(len(ctx.messages_b64))
    if ctx.messages_json_error:
        msg += "Base64 decoding errors: {};  ".format(len(ctx.messages_json_error))
    if ctx.messages_dict_error:
        msg += "JSON encoding errors: {};  ".format(len(ctx.messages_dict_error))
    if ctx.messages_ampq_error:
        msg += "AMPQ encoding errors: {};  ".format(len(ctx.messages_ampq_error))
    if ctx.messages_dict_excluded:
        msg += "Type Exclusions: {};  ".format(len(ctx.messages_dict_excluded))
    if ctx.messages_dict_obsolete:
        msg += "Obsoletes: {};  ".format(len(ctx.messages_dict_obsolete))
    msg += "Outgoing: {}.".format(len(ctx.messages_ampq))

    logger.log_mq(msg)
