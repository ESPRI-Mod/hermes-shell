# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: SMTP server handling utility functions.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import config, mq, rt



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


def dispatch(uid_list):
    """Dispatches messages to MQ server.

    :param list uid_list: List of email unique identifiers for dispatch to email server.

    """
    rt.log_mq("{0} new messages for dispatch: {1}".format(len(uid_list), uid_list))
    mq.produce((get_message(uid) for uid in uid_list),
               connection_url=config.mq.connections.libigcm)
