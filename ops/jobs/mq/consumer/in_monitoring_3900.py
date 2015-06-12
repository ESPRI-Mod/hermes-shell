# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_3900.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 3900 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import in_monitoring_job_fail as base



# MQ exhange to bind to.
MQ_EXCHANGE = base.MQ_EXCHANGE

# MQ queue to bind to.
MQ_QUEUE = mq.constants.QUEUE_IN_MONITORING_3900

# Set of tasks to be executed when processing a message.
get_tasks = base.get_tasks

# Message processing context information.
ProcessingContextInfo = base.ProcessingContextInfo
