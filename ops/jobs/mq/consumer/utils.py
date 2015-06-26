# -*- coding: utf-8 -*-

"""
.. module:: consumer_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Message consumer utility functions.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import os
import subprocess

import arrow

from prodiguer import mq



def enqueue(
    message_type,
    payload=None,
    mq_user_id=mq.constants.USER_PRODIGUER,
    mq_producer_id = mq.constants.PRODUCER_PRODIGUER,
    mq_app_id = mq.constants.APP_MONITORING
    ):
    """Enqueues a message upon MQ server.

    :param str message_type: Message type, e.g. 0000.
    :param dict payload: Message payload.
    :param str mq_user_id: MQ server user id, e.g. prodiguer-mq-user.
    :param str mq_producer_id: MQ server producer id, e.g. lilIGCM.
    :param str mq_app_id: MQ server app id, e.g. monitoring.

    """
    def _get_msg_props():
        """Returns AMPQ message properties.

        """
        return mq.utils.create_ampq_message_properties(
            user_id = mq_user_id,
            producer_id = mq_producer_id,
            app_id = mq_app_id,
            message_type = message_type
            )


    def _yield_message():
        """Yeild a mesage to be enqueued.

        """
        yield mq.Message(_get_msg_props(),
                         payload or {},
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_yield_message)


def get_timestamp(timestamp):
    """Corrects nano-second to micro-second precision and returns updated timestamp.

    :param str timestamp: Incoming message timestamp.

    :return: Formatted micro-second precise UTC timestamp.
    :rtype: datetime.datetime

    """
    try:
        return arrow.get(timestamp).to('UTC').datetime
    except arrow.parser.ParserError:
        part1 = timestamp.split(".")[0]
        part2 = timestamp.split(".")[1].split("+")[0][0:6]
        part3 = timestamp.split(".")[1].split("+")[1]
        timestamp = "{0}.{1}+{2}".format(part1, part2, part3)

        return arrow.get(timestamp).to('UTC').datetime


def exec_shell_command(cmd):
    """Executes a prodiguer-shell command.

    :param str cmd: Prodiguer shell command to be executed.

    """
    # Set prodiguer-shell path.
    shell = os.path.dirname(__file__)
    for _ in range(4):
        shell = os.path.dirname(shell)
    shell = os.path.join(shell, 'exec.sh')

    # Set prodiguer shell command.
    cmd = '{0} {1}'.format(shell, cmd)

    # Invoke command.
    subprocess.call(cmd, shell=True)
