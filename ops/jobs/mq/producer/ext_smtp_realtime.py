# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_realtime.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Realtime IMAP client that enqueus new emails upon MQ server for futher processing.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import time


import sqlalchemy

from prodiguer import config
from prodiguer import mail
from prodiguer import mq
from prodiguer.utils import logger
from prodiguer.db import pgres as db



def _log(msg):
    """Helper function: logs a message.

    """
    func = logger.log_mq_error if isinstance(msg, Exception) else logger.log_mq
    func("EXT-SMTP-REALTIME :: {}".format(msg))


def _get_new_emails():
    """Returns emails to be enqueued upon MQ server.

    """
    # Get emails in SMTP inbox.
    emails = mail.get_email_uid_list()
    if not emails:
        return

    # Exclude those that have already been processed.
    try:
        db.session.start()
        result = []
        for uid in emails:
            try:
                db.dao_mq.create_message_email(uid)
            except sqlalchemy.exc.IntegrityError:
                db.session.rollback()
            else:
                result.append(uid)
    finally:
        db.session.end()

    return result


def _yield_message(uid):
    """Yields a message to be enqueued upon MQ server.

    """
    def _get_props():
        """Returns AMPQ message properties.

        """
        return mq.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP
            )


    def _get_body(uid):
        """Message body factory.

        """
        return {u"email_uid": uid}

    _log("Dispatching email {0} to MQ server".format(uid))
    return mq.Message(_get_props(),
                     _get_body(uid),
                     mq.constants.EXCHANGE_PRODIGUER_EXT)


def _enqueue_emails():
    """Dispatches messages to MQ server.

    """
    # Get new emails.
    uid_list = _get_new_emails()
    if not uid_list:
        return

    # Log.
    msg = "{0} new messages to be enqueued: {1}"
    msg = msg.format(len(uid_list), uid_list)
    _log(msg)

    # Enqueue emails upon MQ server.
    mq.produce((_yield_message(uid) for uid in uid_list),
               connection_url=config.mq.connections.libigcm)


def _requires_imap_reconnect(idle_response):
    """Predicate indicating if IMAP IDLE response indicates connection was dropped.

    """
    # True if response is not a list.
    if not isinstance(idle_response, list):
        return True

    # True if response is empty.
    if len(idle_response) == 0:
        return True

    # True if response is server initiated disconnect.
    if len(idle_response) == 1 and \
         isinstance(idle_response[0], tuple) and \
         idle_response[0][1] == u'BYE':
         return True

    # False otherwise.
    return False


def _requires_enqueue(idle_response):
    """Predicate indicating if IMAP IDLE response indicates new emails to be enqueued upon MQ server.

    """
    # True if server sens an IMAP EXISTS response.
    for data in idle_response:
        if isinstance(data, tuple) and \
           len(data) == 2 and \
           data[1] == u'EXISTS':
           return True

    # False otherwise.
    return False


def _execute():
    """Executes realtime SMTP sourced message production.

    """
    imap_client = None
    try:
        while True:
            # Enqueue existing emails.
            _enqueue_emails()

            # Process IMAP idle events.
            imap_client = mail.connect()
            imap_client.idle()
            while True:
                # ... blocks whilst waiting for idle response
                idle_response = imap_client.idle_check()

                # ... reconnects
                if _requires_imap_reconnect(idle_response):
                    _log("Reconnecting to IMAP server")
                    break

                # ... enqueues
                elif _requires_enqueue(idle_response):
                    _enqueue_emails()

                # ... other responses can be ignored
                else:
                    pass

    # Close IMAP client.
    finally:
        mail.disconnect(imap_client)


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    """
    while True:
        _log("Launching IDLE client")
        try:
            _execute()
        except Exception as err:
            _log(err)
            time.sleep(config.mq.mail.idleFaultRetryDelayInSeconds)
