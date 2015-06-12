# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_4100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 4100 messages (push stack).

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import null_consumer as base


# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_IN

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_4100

# Set of tasks to be executed when processing a message.
get_tasks = base.get_tasks

# Message processing context information.
ProcessingContextInfo = base.ProcessingContextInfo
