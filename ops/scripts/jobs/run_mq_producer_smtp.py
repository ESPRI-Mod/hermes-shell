# -*- coding: utf-8 -*-

"""
.. module:: run_mq_producer_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from an SMTP server and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import base64, imaplib, json

from prodiguer.utils import (
    config,
    convert,
    runtime as rt
    )
from prodiguer import mq



class _ProcessingContext(object):
    """Encapsulates processing contextual information."""
    def __init__(self):
        """Constructor."""
        self.cfg = config.mq.smtp_bridge
        self.imap_client = None
        self.emails = None
        self.messages = []


    def get_email(self, uid):
        """Returns first email with matching identifier."""
        for email in self.emails:
            if email.uid == uid:
                return email


    def get_email_uid_list(self):
        """Returns list of email uid's."""
        return ",".join([email.uid for email in self.emails])


class _Email(object):
    """Wraps an email being processed."""
    def __init__(self, uid):
        """Constructor."""
        self.body = None
        self.decoded = None
        self.header = None
        self.uid = uid


def _init(ctx):
    """Pre processing handler."""
    # Initialize mail server client.
    client = imaplib.IMAP4_SSL(host=ctx.cfg.host,
                               port=int(ctx.cfg.port))
    client.login(ctx.cfg.username, ctx.cfg.password)
    ctx.imap_client = client


def _init_emails(ctx):
    """Initializes set of emails to be processed."""
    # Select mailbox.
    mailbox = ctx.cfg.mailbox
    typ, data = ctx.imap_client.select(mailbox, readonly=True)
    if typ != 'OK':
        raise Exception("An error occurred whilst selecting a mailbox.")

    # Get email identifiers.
    typ, data = ctx.imap_client.search(None, 'ALL')
    if typ != 'OK':
        raise Exception("An error occurred whilst searching a mailbox.")

    # Initialise emails.
    uid_list = data[0].split(" ")
    ctx.emails = [_Email(uid) for uid in uid_list]


def _set_email_details(ctx):
    """Sets details of the emails to be processed."""
    email_uid_list  = ctx.get_email_uid_list()

    def set_email_info(imap_filter, part):
        typ, data = ctx.imap_client.fetch(email_uid_list, imap_filter)
        if typ != 'OK':
            raise Exception("Email {0} retrieval error.".format(part))
        for response in (i for i in data if isinstance(i, tuple)):
            uid = response[0].split(" ")[0]
            info = response[1]
            email = ctx.get_email(uid)
            setattr(email, part, info)

    set_email_info('(BODY.PEEK[TEXT])', 'body')


def _init_messages(ctx):
    """Initializes set of messages to be dispatched."""
    def _yield_messages(email):
        """Returns set of messages embedded in an email."""
        for msg in email.body.split("\n"):
            if not len(msg.strip()):
                continue
            # Base64 decode.
            try:
                msg = base64.b64decode(msg)
            except TypeError as err:
                rt.log_mq_error(Exception("Base64 decoding error:\n{0}".format(msg)))
            else:
                # JSON encode.
                try:
                    yield json.loads(msg)
                except ValueError as err:
                    rt.log_mq_error(Exception("json encoding error:\n{0}".format(msg)))

    for email in ctx.emails:
        ctx.messages += _yield_messages(email)


def _get_ampq_msg_props(type_id, timestamp):
    """Returns an AMPQ basic properties instance, i.e. message header."""
    return mq.utils.create_ampq_message_properties(
        user_id = mq.constants.USER_IGCM,
        producer_id = mq.constants.PRODUCER_IGCM,
        app_id = mq.constants.APP_MONITORING,
        message_type = type_id,
        mode = mq.constants.MODE_TEST,
        timestamp = convert.date_to_timestamp(timestamp))


def _prepare_messages_for_dispatch(ctx):
    """Prepares messages ready for dispatching to MQ server."""
    def transform(message):
        exchange = mq.constants.EXCHANGE_PRODIGUER_IN
        props = _get_ampq_msg_props(message['code'], message['timestamp'])

        return mq.utils.Message(exchange, props, message)

    ctx.messages = (transform(m) for m in ctx.messages)


def _release_smtp_connection(ctx):
    """Closes Performs clean up after mail server resources have been processed."""
    ctx.emails = None
    ctx.imap_client.close()
    ctx.imap_client.logout()


def _dispatch_messages(ctx):
    """Dispatches messages to MQ server."""
    def yield_messages():
        for msg in ctx.messages:
            yield msg

    mq.utils.publish(yield_messages,
                     connection_url=config.mq.connections.libligcm)


def _main():
    """Main entry point handler."""
    def handle_error(ctx, err):
        """Error handler."""
        try:
            rt.log_mq_error(err)
            _release_smtp_connection(ctx)
        # Force job completion by ignoring sub-exceptions.
        except:
            pass

    # Set task list.
    tasks = (
        _init,
        _init_emails,
        _set_email_details,
        _init_messages,
        _release_smtp_connection,
        _prepare_messages_for_dispatch,
        _dispatch_messages
        )

    # Execute tasks.
    ctx = _ProcessingContext()
    try:
        for func in tasks:
            func(ctx)
    except Exception as err:
        handle_error(ctx, err)


# Main entry point.
if __name__ == "__main__":
    _main()
