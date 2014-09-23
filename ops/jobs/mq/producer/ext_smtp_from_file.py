# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from an SMTP server and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, email, json, os

import numpy as np

from prodiguer.utils import config, rt
from prodiguer import mq



# Email file extension.
_EMAIL_FILE_EXTENSION = "eml"


class ProcessingContext(object):
    """Processing context information wrapper."""
    def __init__(self, throttle, dirpath):
        """Constructor."""
        self.attachment_decoding_errors = []
        self.content_decoding_errors = []
        self.content_encoding_errors = []
        self.dirpath = dirpath
        self.mails = []
        self.files = []
        self.messages = []
        self.produced = 0
        self.throttle = throttle


    def get_attachments(self):
        """Returns set of attachments."""
        return [m.attachment for m in self.messages if m.attachment]


    def reset_messages(self):
        """Resets the messages stack."""
        def _is_in_error(msg):
            return m.err or (m.attachment and m.attachment.err)

        self.messages = [m for m in self.messages if not _is_in_error(m)]


    def get_message(self, msg_id):
        """Retrieves first message with a matching id."""
        for msg in self.messages:
            if msg.id == msg_id:
                return msg



class _Mail(object):
    """An email for processing."""
    def __init__(self, content, attachment, fpath):
        if attachment:
            self.attachment = _get_lines(attachment)[0]
            self.content = _get_lines(content)[0]
        else:
            self.attachment = None
            self.content = _get_lines(content)
        self.err = None
        self.fpath = fpath


class _Message(object):
    """A message being processed from an email."""
    def __init__(self, content, attachment, fpath):
        self.content = content
        self.attachment = attachment
        self.err = None
        self.fpath = fpath
        self.id = None


class _Base64DecodingException(Exception):
    """Custom exception: raise when a base64 decoding exception occurs."""
    pass


class _JSONEncodingException(Exception):
    """Custom exception: raise when a json encoding exception occurs."""
    pass


def _get_lines(text):
    """Helper function: splits text into lines"""
    return [l.strip() for l in text.split("\n") if l.strip()]


def _get_timestamp(timestamp):
    """Helper function: returns a formatted timestamp."""
    timestamp = np.datetime64(timestamp, dtype="datetime64[ns]")

    return timestamp.astype(long)


def _get_message_bounding_errors(ctx):
    """Helper function: returns set of messages that bracket encoding/decoding errors."""
    def _get_filtered(offset):
        result = []
        for msg in [m for m in ctx.messages if not m.err]:
            msg1 = ctx.get_message(msg.id + offset)
            if msg1 and msg1.err:
                result.append(msg)

        return result

    return _get_filtered(1), _get_filtered(-1)


def _decode_b64(data):
    """Helper function: decodes base64 encoded text."""
    try:
        return base64.b64decode(data)
    except TypeError as err:
        raise _Base64DecodingException(err)


def _encode_json(data):
    """Helper function: encodes json encoded text."""
    try:
        return json.loads(data)
    except ValueError as err:
        raise _JSONEncodingException(err)


def _set_files(ctx):
    """Sets files to be processed."""
    if not os.path.exists(ctx.dirpath):
        raise ValueError("Directory does not exist: {0}.".format(ctx.dirpath))
    ctx.files = [os.path.join(ctx.dirpath, f) for f in os.listdir(ctx.dirpath) \
                if str.lower(f[-3:])==_EMAIL_FILE_EXTENSION]
    if not ctx.files:
        raise ValueError("No email files to process.")


def _set_emails(ctx):
    """Sets emails to be processed."""
    for fpath in ctx.files:
        mail = email.message_from_file(open(fpath))
        payload = mail.get_payload()
        if isinstance(payload, str):
            ctx.mails.append(_Mail(payload, None, fpath))
        elif isinstance(payload, list) and len(payload) == 2:
            ctx.mails.append(_Mail(payload[0].get_payload(decode=True),
                                   payload[1].get_payload(decode=True),
                                   fpath))
        else:
            raise TypeError("Email payload must either be a set of messages or a message with an attachement.")


def _set_messages(ctx):
    """Set messages to be processed."""
    # Create messages.
    for mail in ctx.mails:
        if mail.attachment:
            ctx.messages.append(_Message(mail.content, mail.attachment, mail.fpath))
        else:
            ctx.messages += [_Message(row, None, mail.fpath) for row in  mail.content]

    # Set messages id's.
    for i, msg in enumerate(ctx.messages):
        msg.id = i


def _decode(ctx):
    """Decodes message content/attachment to plain text."""
    for msg in ctx.messages:
        try:
            msg.content = _decode_b64(msg.content)
            if msg.attachment:
                msg.attachment = _decode_b64(msg.attachment)
        except _Base64DecodingException as err:
            msg.err = err


def _encode(ctx):
    """Encodes message content to a dict from json."""
    for msg in [m for m in ctx.messages if not m.err]:
        try:
            msg.content = _encode_json(msg.content)
        except _JSONEncodingException as err:
            msg.err = err


def _write_errors(ctx):
    """Writes processing errors to file system."""
    msg_list1, msg_list2 = _get_message_bounding_errors(ctx)
    fpath = '/Users/macg/dev/tmp/libigcm_mq_issues.txt'
    with open(fpath, 'w') as ofile:
        for i in range(len(msg_list1)):
            ofile.write("----------------------------------------------------------------------------------------------\n")
            ofile.write("******   MESSAGE PRECEDENTE   ******")
            ofile.write("\n")
            ofile.write(msg_list1[i].fpath)
            ofile.write("\n")
            ofile.write(str(msg_list1[i].content))
            ofile.write("\n")
            ofile.write("******   MESSAGE SUIVANTE   ******")
            ofile.write("\n")
            ofile.write(msg_list2[i].fpath)
            ofile.write("\n")
            ofile.write(str(msg_list2[i].content))
            ofile.write("\n")
            ofile.write("******   NOMBRE DES MESSAGES PROBLEMATIQUE ENTRE CES DEUX   ******")
            ofile.write("\n")
            ofile.write(str(msg_list2[i].id - msg_list1[i].id))
            ofile.write("\n----------------------------------------------------------------------------------------------\n")


def _log_stats(ctx):
    """Logs parsing stats."""
    rt.log_mq("Parsed {0} messages; Decoding errors = {1}; Encoding errors = {2}".format(
        len(ctx.messages),
        len([m for m in ctx.messages if isinstance(m.err, _Base64DecodingException)]),
        len([m for m in ctx.messages if isinstance(m.err, _JSONEncodingException)])))


def _format_timestamp(ctx):
    """Formats message timestamps."""
    for msg in [m for m in ctx.messages if not m.err]:
        ts0 = msg.content['msgTimestamp']
        msg.content['msgTimestamp'] = "{0}T{1}.{2}".format(ts0[0:10],
                                                           ts0[11:19],
                                                           ts0[20:])


def _dispatch(ctx):
    """Dispatches messages to MQ server."""
    def _get_msg_props(msg):
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_id = msg.content['msgUID'],
            message_type = msg.content['msgCode'],
            mode = mq.constants.MODE_TEST,
            timestamp = _get_timestamp(msg.content['msgTimestamp']))

    def _get_messages():
        """Dispatch message source."""
        for msg in [m for m in ctx.messages if not m.err]:
            yield mq.Message(_get_msg_props(msg),
                             msg.content,
                             mq.constants.EXCHANGE_PRODIGUER_IN)
            # Apply throttle.
            ctx.produced += 1
            if ctx.throttle and ctx.throttle == ctx.produced:
                return

    mq.produce(_get_messages,
               connection_url=config.mq.connections.libigcm)



# Set of processing tasks.
TASKS = {
    "green": (
        _set_files,
        _set_emails,
        _set_messages,
        _decode,
        _encode,
        _format_timestamp,
        _log_stats,
        # _write_errors,
        _dispatch,
        ),
    "red": ()
}
