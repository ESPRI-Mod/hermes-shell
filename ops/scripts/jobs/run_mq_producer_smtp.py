# -*- coding: utf-8 -*-

"""
.. module:: run_mq_producer_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from an SMTP server and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import imaplib

from prodiguer.utils import (
    config,
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


def _init_imap_client(ctx):
    """Initializes imap client used to communicate with email server."""
    client = imaplib.IMAP4_SSL(host=ctx.cfg.host,
                               port=int(ctx.cfg.port))
    client.login(ctx.cfg.username, ctx.cfg.password)
    ctx.imap_client = client


def _init_emails(ctx):
    """Initializes set of emails to be processed."""
    # Select mailbox.
    typ, data = ctx.imap_client.select(ctx.cfg.mailbox,
                                       readonly=True)
    if typ != 'OK':
        raise Exception("An error occurred whilst selecting a mailbox.")

    # Get email identifiers.
    typ, data = ctx.imap_client.search(None, 'ALL')
    if typ != 'OK':
        raise Exception("An error occurred whilst searching a mailbox.")

    # Initialise emails.
    uid_list = data[0].split(" ")
    ctx.emails = uid_list


def _init_messages(ctx):
    """Initializes set of messages to be dispatched."""
    def _get_ampq_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST)

    def transform(email_uid):
        """Transforms an email id to a message ready for dispatch."""
        return mq.utils.Message(_get_ampq_msg_props(),
                                {"email_uid": email_uid},
                                mq.constants.EXCHANGE_PRODIGUER_EXT)

    ctx.messages = (transform(email_id) for email_id in ctx.emails)


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
    # Define tasks.
    tasks = {
        "green": (
            _init_imap_client,
            _init_emails,
            _init_messages,
            _release_smtp_connection,
            _dispatch_messages
            ),
        "red": (
            _release_smtp_connection,
            )
    }

    # Invoke tasks.
    rt.invoke(tasks, _ProcessingContext(), "MQ")


# Main entry point.
if __name__ == "__main__":
    _main()
