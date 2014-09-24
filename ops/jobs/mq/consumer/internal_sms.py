# -*- coding: utf-8 -*-

"""
.. module:: internal_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends notifications to an SMTP server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_INTERNAL_SMS



# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=True)

        self.notification_type = None
        self.operator_id = None
        self.operator = None
        self.template = None


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return (
        _unpack_content,
        _set_operator,
        _set_template,
        _set_content,
        _dispatch
        )


def _unpack_content(ctx):
    """Unpacks information from message content."""
    ctx.notification_type = ctx.content['notificationType']
    ctx.operator_id = ctx.content['operatorID']


def _set_operator(ctx):
    """Sets information regarding operator."""
    # TODO: load operator details.
    pass


def _set_template(ctx):
    """Sets template of sms to be dispatched."""
    # TODO: load sms template.
    pass


def _set_content(ctx):
    """Sets content of sms to be dispatched."""
    # TODO: interpolate sms template.
    pass


def _dispatch(ctx):
    """Dispatches an sms to an operator."""
    # TODO: dispatch sms to operator.
    pass
