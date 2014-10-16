# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_2000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 2000 messages.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import in_monitoring_utils as utils



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_2000


def get_tasks():
    """Returns set of tasks to be executed when processing a message."""
    return _persist_job_command_info


# Message information wrapper.
class Message(mq.Message):
    """Message information wrapper."""
    def __init__(self, props, body, decode=True):
        """Constructor."""
        super(Message, self).__init__(props, body, decode=decode)

        self.simulation_uid = self.content['simuid']


def _persist_job_command_info(ctx):
    """Persists job command information to db."""
    # TODO

