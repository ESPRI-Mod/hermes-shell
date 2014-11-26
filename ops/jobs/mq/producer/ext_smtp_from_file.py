# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_from_file.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls emails saved to a file system and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, email, json, os, uuid

from prodiguer import config, mq, rt



# Email file extension.
_EMAIL_FILE_EXTENSION = "eml"


def get_tasks():
    """Returns set of message processing tasks to be executed.

    """
    return (
        _set_files,
        _set_emails,
        _set_messages_b64,
        _set_messages_json,
        _set_messages_dict,
        _update_messages_dict,
        _set_messages_ampq,
        _dispatch,
        )


class ProcessingContext(object):
    """Processing context information wrapper.

    """
    def __init__(self, throttle, dirpath):
        """Object constructor."""
        self.dirpath = dirpath
        self.files = []
        self.mails = []
        self.messages = []
        self.messages_b64 = []
        self.messages_json = []
        self.messages_json_error = []
        self.messages_dict = []
        self.messages_dict_error = []
        self.produced = 0
        self.throttle = throttle
        self.uid_map = {}


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


def _get_correlation_id(msg):
    """Returns correlation id from message body.

    """
    # TODO - also jobuid ?
    if 'simuid' in msg:
        return msg['simuid']
    else:
        return None


def _get_msg_basic_props(msg):
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


def _set_files(ctx):
    """Sets files to be processed.

    """
    if not os.path.exists(ctx.dirpath):
        raise ValueError("Invalid directory: {0}.".format(ctx.dirpath))
    ctx.files = [os.path.join(ctx.dirpath, f) for f in os.listdir(ctx.dirpath) \
                if str.lower(f[-3:])==_EMAIL_FILE_EXTENSION]
    if not ctx.files:
        raise ValueError("Invalid directory (no .eml files): {0}.".format(ctx.dirpath))


def _set_emails(ctx):
    """Sets emails to be processed.

    """
    for mail in [email.message_from_file(open(f, 'r')) for f in ctx.files]:
        if mail.is_multipart():
            mail, attachment = mail.get_payload()
            print "TODO: process attachment"
        ctx.mails.append(mail.get_payload(decode=True))


def _set_messages_b64(ctx):
    """Sets base64 encoded messages to be processed.

    """
    for mail in ctx.mails:
        ctx.messages_b64 += [l for l in mail.splitlines() if l]

    rt.log_mq("Raw messages:", len(ctx.messages_b64))


def _set_messages_json(ctx):
    """Decode json encoded strings from base64 encoded string.

    """
    for msg in [_decode_b64(m) for m in ctx.messages_b64]:
        if isinstance(msg, tuple):
            ctx.messages_json_error.append(msg)
        else:
            ctx.messages_json.append(msg)

    rt.log_mq("Base64 decoding errors: ", len(ctx.messages_json_error))


def _set_messages_dict(ctx):
    """Encode json encoded strings to dictionaries.

    """
    for msg in [_encode_json(m) for m in ctx.messages_json]:
        if isinstance(msg, tuple):
            ctx.messages_dict_error.append(msg)
        else:
            ctx.messages_dict.append(msg)

    rt.log_mq("Json encoding errors: ", len(ctx.messages_dict_error))


def _update_messages_dict(ctx):
    """Updates message dictionaries to ensure message uniqueness constraints pass.

    """
    def _set_new_uid(msg, key):
        """Sets new universally unique identifier.

        """
        if key in msg:
            if msg[key] not in ctx.uid_map:
                ctx.uid_map[msg[key]] = unicode(uuid.uuid4())
            msg[key] = ctx.uid_map[msg[key]]

    for msg in ctx.messages_dict:
        if 'msgUID' in msg:
            msg['msgUID'] = unicode(uuid.uuid4())
        if 'simuid' in msg:
            _set_new_uid(msg, 'simuid')
            if 'name' in msg:
                msg['name'] = "{0} - {1}".format(msg['name'], unicode(uuid.uuid4()))
        if 'jobuid' in msg:
            _set_new_uid(msg, 'jobuid')


def _set_messages_ampq(ctx):
    """Set AMPQ messages to be dispatched.

    """
    for msg in ctx.messages_dict:
        ctx.messages.append(mq.Message(_get_msg_basic_props(msg),
                                       _get_msg_payload(msg),
                                       mq.constants.EXCHANGE_PRODIGUER_IN))

    rt.log_mq("AMPQ messages for dispatch to MQ server: ", len(ctx.messages))


def _dispatch(ctx):
    """Dispatches messages to MQ server.

    """
    def _get_messages():
        """Message source.

        """
        for msg in ctx.messages:
            yield msg
            ctx.produced += 1
            if ctx.throttle and ctx.throttle == ctx.produced:
                return

    mq.produce(_get_messages, connection_url=config.mq.connections.libigcm)

