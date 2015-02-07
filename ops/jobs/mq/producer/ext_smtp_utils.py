# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: SMTP server handling utility functions.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from sqlalchemy.exc import IntegrityError

from prodiguer import config, db, mail, mq, rt



def get_message(uid):
    """Returns a message for dispatch to MQ server.

    :param str uid: Unique identifier of email being processed.

    """
    def _get_props():
        """Message properties factory.

        """
        return mq.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST)


    def _get_body(uid):
        """Message body factory.

        """
        return {u"email_uid": uid}


    rt.log_mq("Dispatching email {0} to MQ server".format(uid))

    return mq.Message(_get_props(),
                      _get_body(uid),
                      mq.constants.EXCHANGE_PRODIGUER_EXT)


def get_emails_for_dispatch(imap_client=None):
    """Returns set of emails to be dispatched to MQ server.

    """
    # Get target emails.
    targets = mail.get_email_uid_list(imap_client)
    if not targets:
        return

    # Exclude those that have already been processed.
    try:
        db.session.start()
        result = []
        for uid in targets:
            try:
                db.dao_mq.create_message_email(uid)
            except IntegrityError:
                db.session.rollback()
            else:
                result.append(uid)
    finally:
        db.session.end()

    return result


def dispatch(imap_client=None):
    """Dispatches messages to MQ server.

    :param imapclient.IMAPClient client: An imap server client.

    """
    # Escape if there are no emails to be dispatched.
    uid_list = get_emails_for_dispatch(imap_client)
    if not uid_list:
        return

    # Log.
    msg = "{0} new messages for dispatch: {1}"
    msg = msg.format(len(uid_list), uid_list)
    rt.log_mq(msg)

    # Dispatch emails to MQ server for further processing.
    mq.produce((get_message(uid) for uid in uid_list),
               connection_url=config.mq.connections.libigcm)
