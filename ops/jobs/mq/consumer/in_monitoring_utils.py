# -*- coding: utf-8 -*-

"""
.. module:: in_monitoring_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Monitoring message consumer utility functions.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import arrow

from prodiguer import db, mq



def _dispatch_message(data, message_type):
    """Dispatches message to MQ server for subsequent processing.

    """
    def _get_msg_props():
        """Message properties factory.

        """
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = message_type,
            mode = mq.constants.MODE_TEST)


    def _get_message():
        """Message factory.

        """
        yield mq.Message(_get_msg_props(),
                         data,
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)


    mq.produce(_get_message)


def get_name(entity_type, entity_id):
    """Utility function to map a db entity id to an entity name.

    """
    return db.cache.get_name(entity_type, entity_id)


def get_timestamp(timestamp):
    """Returns formatted timestamp for insertion into db.

    This is necessary due to nano-second to second precision errors.

    """
    try:
        return arrow.get(timestamp).to('Europe/Paris').datetime
    except arrow.parser.ParserError:
        part1 = timestamp.split(".")[0]
        part2 = timestamp.split(".")[1].split("+")[0][0:6]
        part3 = timestamp.split(".")[1].split("+")[1]
        timestamp = "{0}.{1}+{2}".format(part1, part2, part3)

        return arrow.get(timestamp).to('Europe/Paris').datetime


def notify_api_of_simulation_state_change(uid, state):
    """Notifies web API of a simulation state change event.

    :param str uid: UID of simulation being processed.
    :param str state: New state of simulation being processed.

    """
    data = {
        u"event_type": "simulation_state_change",
        u"uid": unicode(uid),
        u"state": state
    }

    _dispatch_message(data, mq.constants.TYPE_GENERAL_API)


def notify_api_of_new_simulation(simulation):
    """Notifies web API of a new simulation event.

    :param dict simulation: Simulation information.

    """
    data = {
        u"event_type": "new_simulation"
    }
    data.update(simulation)

    _dispatch_message(data, mq.constants.TYPE_GENERAL_API)


def notify_operator(uid, notification_type):
    """Notifies operator of a simulation event of interest.

    :param str uid: UID of simulation being processed.
    :param dict notification_info: Notification information.

    """
    data = {
        'notificationType': notification_type,
        'simulation_uid': uid
    }

    _dispatch_message(data, mq.constants.TYPE_GENERAL_SMTP)
    _dispatch_message(data, mq.constants.TYPE_GENERAL_SMS)
