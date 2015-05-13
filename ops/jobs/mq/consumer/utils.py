# -*- coding: utf-8 -*-

"""
.. module:: consumer_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Message consumer utility functions.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import os, subprocess

import arrow

from prodiguer import mq



def dispatch_message(
    data,
    message_type,
    mq_user_id=mq.constants.USER_PRODIGUER,
    mq_producer_id = mq.constants.PRODUCER_PRODIGUER,
    mq_app_id = mq.constants.APP_MONITORING
    ):
    """Dispatches message to MQ server for subsequent processing.

    """
    def _get_msg_props():
        """Message properties factory.

        """
        return mq.utils.create_ampq_message_properties(
            user_id = mq_user_id,
            producer_id = mq_producer_id,
            app_id = mq_app_id,
            message_type = message_type
            )


    def _get_message():
        """Message factory.

        """
        yield mq.Message(_get_msg_props(),
                         data or {},
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)


    mq.produce(_get_message)



def get_timestamp(timestamp):
    """Returns formatted timestamp for insertion into db.

    This is necessary due to nano-second to second precision errors.

    """
    try:
        return arrow.get(timestamp).to('UTC').datetime
    except arrow.parser.ParserError:
        part1 = timestamp.split(".")[0]
        part2 = timestamp.split(".")[1].split("+")[0][0:6]
        part3 = timestamp.split(".")[1].split("+")[1]
        timestamp = "{0}.{1}+{2}".format(part1, part2, part3)

        return arrow.get(timestamp).to('UTC').datetime


def notify_operator(uid, notification_type):
    """Notifies operator of a simulation event of interest.

    :param str uid: UID of simulation being processed.
    :param dict notification_info: Notification information.

    """
    # Skip until notification strategy is better defined.
    return

    data = {
        'notificationType': notification_type,
        'simulation_uid': uid
    }

    dispatch_message(data, mq.constants.TYPE_GENERAL_SMTP)
    dispatch_message(data, mq.constants.TYPE_GENERAL_SMS)


def exec_shell_command(cmd):
    """Executes a prodiguer-shell command.

    :param str cmd: Prodiguer shell command to be executed.

    """
    # Set path to shell.
    shell = os.path.dirname(__file__)
    for _ in range(4):
        shell = os.path.dirname(shell)
    shell = os.path.join(shell, 'exec.sh')

    # Set command.
    cmd = '{0} {1}'.format(shell, cmd)

    # Invoke command.
    subprocess.call(cmd, shell=True)
