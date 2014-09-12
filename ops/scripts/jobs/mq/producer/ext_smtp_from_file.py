# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_from_file.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Pulls messages on the file system (originally pulled from an SMTP server) and forwards them to the MQ server.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""


import os, sys



class ProcessingContext(object):
    """Processing context information wrapper."""
    def __init__(self, batch_id, throttle=0):
        """Constructor."""
        self.batch_id = batch_id
        self.throttle = throttle
        self.produced = 0
        self.messages = []


def _init_messages(ctx):
    """Initializes set of messages to be processed."""
    print("Hello Dolly")


# Set of processing tasks.
TASKS = {
    "green": (
    	_init_messages,
    	),
    "red": ()
}