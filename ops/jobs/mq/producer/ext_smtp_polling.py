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
import ext_smtp_utils as utils



def get_tasks():
    """Returns set of message processing tasks to be executed.

    """
    return (
        _init,
        _dispatch
        )


class ProcessingContext(object):
    """Processing context information wrapper.

    """
    def __init__(self, throttle):
        """Object constructor.

        """
        self.email_uid_list = None
        self.throttle = throttle
        self.produced = 0


def _init(ctx):
    """Initialization routine.

    """
    ctx.email_uid_list = mail.get_email_uid_list()


def _dispatch(ctx):
    """Dispatches messages to MQ server.

    """
    def _get_messages():
        """Dispatch message source.

        """
        for uid in ctx.email_uid_list:
            yield utils.get_message(uid)
            ctx.produced += 1
            if ctx.throttle and ctx.throttle == ctx.produced:
                return

    rt.log_mq("Messages for dispatch: {0}".format(ctx.email_uid_list))
    mq.produce(_get_messages,
               connection_url=config.mq.connections.libigcm)

