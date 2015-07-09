# -*- coding: utf-8 -*-

"""
.. module:: run_in_monitoring_3000.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Consumes monitoring 3000 messages.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import cv
from prodiguer import mq

import in_monitoring_job_start as base



# Set of tasks to be executed when processing a message.
get_tasks = base.get_tasks


class ProcessingContextInfo(base.ProcessingContextInfo):
    """Message processing context information.

    """
    def __init__(self, props, body, decode=True):
        """Object constructor.

        """
        super(ProcessingContextInfo, self).__init__(
            props, body, decode=decode)

        self.job_type = cv.constants.JOB_TYPE_POST_PROCESSING_FROM_CHECKER
