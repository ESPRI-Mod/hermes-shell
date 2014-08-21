# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp.py
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
        self.email_uid_list = None
        self.messages = []


def _init_imap_client(ctx):
    """Initializes imap client used to communicate with email server."""
    # Login to mail server.
    client = imaplib.IMAP4_SSL(host=ctx.cfg.host,
                               port=int(ctx.cfg.port))
    client.login(ctx.cfg.username, ctx.cfg.password)
    ctx.imap_client = client

    # Set mailbox.
    ctx.imap_client.select(ctx.cfg.mailbox, readonly=True)


def _init_email_uid_list(ctx):
    """Initializes set of emails to be processed."""
    # Search mailbox.
    typ, data = ctx.imap_client.search(None, 'ALL')
    if typ != 'OK':
        raise Exception("An error occurred whilst searching a mailbox.")

    # Initialise list of email uid's.
    ctx.email_uid_list = data[0].split(" ")


def _close_imap_client(ctx):
    """Closes imap client."""
    ctx.imap_client.close()
    ctx.imap_client.logout()


def _dispatch(ctx):
    """Dispatches messages to MQ server."""
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST)

    def _get_msg_body(uid):
        """Returns message body."""
        return {u"email_uid": uid}

    def _get_messages():
        """Dispatch message source."""
        for uid in ctx.email_uid_list:
            yield mq.Message(_get_msg_props(),
                             _get_msg_body(uid),
                             mq.constants.EXCHANGE_PRODIGUER_EXT)

    mq.produce(_get_messages,
               connection_url=config.mq.connections.libligcm)


def _main():
    """Main entry point handler."""
    # Define tasks.
    tasks = {
        "green": (
            _init_imap_client,
            _init_email_uid_list,
            _close_imap_client,
            _dispatch
            ),
        "red": (
            _close_imap_client,
            )
    }

    # Invoke tasks.
    rt.invoke(tasks, _ProcessingContext(), "MQ")


# Main entry point.
if __name__ == "__main__":
    _main()
