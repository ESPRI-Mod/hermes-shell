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


def _get_emails_for_dispatch():
    """Returns set of emails to be dispatched to MQ server.

    """
    # Build list of emails requiring processing.
    uid_list = []
    for uid in mail.get_email_uid_list():
        try:
            db.dao_mq.create_message_email(uid)
        except IntegrityError:
            db.session.rollback()
        else:
            uid_list.append(uid)

    return uid_list


def dispatch():
    """Dispatches messages to MQ server.

    """
    # Escape if there are no emails to be dispatched.
    uid_list = _get_emails_for_dispatch()
    if not uid_list:
        return

    # Dispatch emails to MQ server for further processing.
    rt.log_mq("{0} new messages for dispatch: {1}".format(len(uid_list), uid_list))
    mq.produce((get_message(uid) for uid in uid_list),
               connection_url=config.mq.connections.libigcm)
