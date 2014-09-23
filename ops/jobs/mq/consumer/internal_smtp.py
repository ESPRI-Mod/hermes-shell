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

        self.mail = None
        self.mail_body = None
        self.mail_subject = "IPSL {0} ({1}) :: ".format(props.app_id.upper(), props.headers['mode'].upper())
        self.notification_type = None
        self.operator = None
        self.operator_id = None
        self.template_body = None
        self.template_subject = None


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
    for fpath in os.listdir(_TEMPLATES_DIRPATH):
        print fpath, fpath[-3:]
    print "TODO:: cache templates"


def _unpack_content(ctx):
    """Unpacks information from message content."""
    print ctx.content
    ctx.notification_type = ctx.content['notificationType']
    ctx.operator_id = ctx.content['operatorID']
    ctx.simulation = ctx.content['simulation']
    ctx.simulation_uid = ctx.content['simulation']['uid']
    ctx.simulation_name = ctx.content['simulation']['name']


def _set_operator(ctx):
    """Sets information regarding operator."""
    ctx.operator = db.cache.get_item(db.types.ComputeNodeLogin, ctx.operator_id)


def _set_templates(ctx):
    """Sets template of email to be dispatched."""
    ctx.template_body = _TEMPLATES.load(ctx.notification_type + "-body.txt")
    ctx.template_subject = _TEMPLATES.load(ctx.notification_type + "-subject.txt")


def _set_mail(ctx):
    """Sets email to be dispatched."""
    ctx.mail_body = ctx.template_body.generate()
    ctx.mail_subject += \
        ctx.template_subject.generate(simulation=ctx.simulation)
    print "TODO: interpolate email templates."
    print ctx.mail_body, ctx.mail_subject
    return

    mail_body = "{0} body goes here".format(ctx.notification_type)
    mail_subject = "{0} subject goes here".format(ctx.notification_type)
    mail_from = "momipsl@ipsl.jussieu.fr"
    mail_to = "momipsl@ipsl.jussieu.fr"

    mail = MIMEText(mail_body)
    mail['Subject'] = mail_subject
    mail['From'] = mail_from
    mail['To'] = mail_to

    ctx.mail = mail


def _dispatch(ctx):
    """Dispatches an email to an operator."""
    print "TODO: dispatch email ..."
    return

    # server = smtplib.SMTP('smtp.ipsl.jussieu.fr')
    server = smtplib.SMTP('134.157.176.41', port=993)

    print "server created ..."
    try:
        server.set_debuglevel(True)
        server.ehlo()
        if server.has_extn('STARTTLS'):
            server.starttls()
            print "ssl session started"
        print "connected to ", server
        server.login("momipsl@ipsl,jussieu.fr", "N@ture93!")
        print "logged in"
        response = server.sendmail("momipsl@ipsl.jussieu.fr",
                                   "momipsl@ipsl.jussieu.fr",
                                   ctx.mail.as_string())
        print "mail sent", response
    except Exception as err:
        print err
    finally:
        server.quit()
        print "logged out of server ..."
