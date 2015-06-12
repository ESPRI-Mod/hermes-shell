# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_1100.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 1100 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mq

import in_monitoring_job_end as base



# Set of tasks to be executed when processing a message.
get_tasks = base.get_tasks

# Message processing context information.
ProcessingContextInfo = base.ProcessingContextInfo
