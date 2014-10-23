# -*- coding: utf-8 -*-

"""
.. module:: internal_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends notifications to an SMTP server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import os, smtplib
from email.mime.text import MIMEText
from os.path import abspath, dirname, join

import tornado.template as template

from prodiguer import mq, db



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_INTERNAL_SMTP

# Templates directory.
_TEMPLATES_DIRPATH = join(dirname(abspath(__file__)), "smtp_templates")

# Templates.
_TEMPLATES = {}
_TEMPLATES = template.Loader(_TEMPLATES_DIRPATH)


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.notification_type = None


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _unpack_content,
        _set_operator,
        _set_templates,
        _set_mail,
        _dispatch
        )


def get_init_tasks():
    """Returns set of consumer initialization tasks."""
    return _cache_templates


def _cache_templates():
    """Places templates in a memory cache."""
    pass


def _unpack_content(ctx):
    """Unpacks information from message content."""
    ctx.notification_type = ctx.content['notificationType']


def _set_operator(ctx):
    """Sets operator information loaded from dB."""
    pass


def _set_templates(ctx):
    """Sets template of email to be dispatched."""
    # ctx.template_body = _TEMPLATES.load(ctx.notification_type + "-body.txt")
    # ctx.template_subject = _TEMPLATES.load(ctx.notification_type + "-subject.txt")
    pass

def _set_mail(ctx):
    """Sets email to be dispatched."""
    # TODO: interpolate email templates
    pass


def _dispatch(ctx):
    """Dispatch email to operator."""
    # TODO: dispatch email
    pass
