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



def _get_entity(entity_type, entity_id):
    """Helper function: return a cached db entity mapped by type and id."""
    return db.cache.get_item(entity_type, entity_id)


def get_name(entity_type, entity_id):
    """Utility function to map a db entity id to an entity name."""
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


def update_simulation_state(ctx, simulation_state):
    """Updates state of a simulation.

    :param object ctx: Message processing context information wrapper.
    :param str simulation_state: New state of simulation being processed.

    """
    # Update state in db & cache simulation info.
    ctx.simulation = mq.db_hooks.update_simulation_status(
        ctx.simulation_uid, simulation_state)

    # Notify api.
    notify_api_of_simulation_state_change(ctx.simulation_uid, simulation_state)


def notify_api_of_simulation_state_change(simulation_uid, simulation_state):
    """Notifies web API of a simulation state change event.

    :param str simulation_uid: UID of simulation being processed.
    :param str simulation_state: New state of simulation being processed.

    """
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_API,
            mode = mq.constants.MODE_TEST)

    def _get_msg_body():
        """Returns message body."""
        return {
            u"event_type": "simulation_state_change",
            u"uid": unicode(simulation_uid),
            u"state": simulation_state
            }

    def _get_message():
        """Dispatch message source."""
        yield mq.Message(_get_msg_props(),
                         _get_msg_body(),
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_get_message)


def notify_api(event_info):
    """Notifies web API of an event of interest.

    :param str body: Event information.

    """
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_API,
            mode = mq.constants.MODE_TEST)

    def _get_message():
        """Dispatch message source."""
        yield mq.Message(_get_msg_props(),
                         event_info,
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_get_message)


def _set_smtp_notification(notification_type, data):
    """Adds an smtp notification to internal-smtp message queue.

    """
    def _get_msg_props():
        """Message properties factory.

        """
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST)


    def _get_message_content():
        """Message content factory.

        """
        return {
            'notificationType': notification_type,
            'operatorID': data['compute_node_login_id'],
            'simulation': {
                'name': data['name'],
                'uid': data['uid'],
                'id': data['id']
            }
        }


    def _get_message():
        """Message factory.

        """
        yield mq.Message(_get_msg_props(),
                         _get_message_content(),
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)


    mq.produce(_get_message)


def _set_sms_notification(notification_type, data):
    """Adds an sms notification to internal-sms message queue.

    """
    def _get_msg_props():
        """Message properties factory.

        """
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMS,
            mode = mq.constants.MODE_TEST)


    def _get_message_content():
        """Message content factory.

        """
        return {
            'notificationType': notification_type,
            'operatorID': data['compute_node_login_id'],
            'simulation': {
                'name': data['name'],
                'uid': data['uid'],
                'id': data['id']
            }
        }


    def _get_message():
        """Message factory.

        """
        yield mq.Message(_get_msg_props(),
                         _get_message_content(),
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)


    mq.produce(_get_message)


def notify_operator(notification_type, data):
    """Notifies operator of an event of interest.

    :param object data: Notification data.
    :param dict notification_info: Notification information.

    """
    _set_smtp_notification(notification_type, data)
    _set_sms_notification(notification_type, data)
