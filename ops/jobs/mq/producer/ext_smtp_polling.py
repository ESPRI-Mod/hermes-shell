# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages from an SMTP server and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import config, mail, mq, rt



def get_tasks():
    """Returns set of message processing tasks to be executed.

    """
    return (
        _init,
        _close_imap_proxy,
        _dispatch
        )


def get_error_tasks():
    """Returns set of message processing tasks to be executed.

    """
    return (
        _close_imap_proxy
        )


class ProcessingContext(object):
    """Processing context information wrapper.

    """
    def __init__(self, throttle):
        """Object constructor.

        """
        self.proxy = None
        self.email_uid_list = None
        self.throttle = throttle
        self.produced = 0


def _get_message(uid):
    """Returns a message for dispatch to MQ server.

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


def _init(ctx):
    """Initialization routine.

    """
    # Initialize imap proxy.
    ctx.proxy = mail.get_imap_proxy()

    # Initialize emails to be processed.
    ctx.email_uid_list = mail.get_email_uid_list(ctx.proxy)


def _close_imap_proxy(ctx):
    """Closes imap client.

    """
    mail.close_imap_proxy(ctx.proxy)


def _dispatch(ctx):
    """Dispatches messages to MQ server.

    """
    def _get_messages():
        """Dispatch message source.

        """
        for uid in ctx.email_uid_list:
            yield _get_message(uid)
            ctx.produced += 1
            if ctx.throttle and ctx.throttle == ctx.produced:
                return

    rt.log_mq("Messages for dispatch: {0}".format(ctx.email_uid_list))
    mq.produce(_get_messages,
               connection_url=config.mq.connections.libigcm)

