# -*- coding: utf-8 -*-

"""
.. module:: internal_smtp.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Sends notifications to an SMTP server.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import null_consumer as base



# MQ exhange to bind to.
MQ_EXCHANGE = mq.constants.EXCHANGE_PRODIGUER_INTERNAL

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_INTERNAL_SMTP

# Set of tasks to be executed when processing a message.
get_tasks = base.get_tasks

# Message processing context information.
ProcessingContextInfo = base.ProcessingContextInfo
