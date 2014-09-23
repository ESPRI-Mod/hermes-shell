# -*- coding: utf-8 -*-

"""
.. module:: in_monitoring_utils.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Monitoring message consumer utility functions.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import db, convert, mq



def _get_entity(entity_type, entity_id):
    """Helper function: return a cached db entity mapped by type and id."""
    return db.cache.get_item(entity_type, entity_id)


def update_simulation_state(ctx, simulation_state):
    """Updates state of a simulation.

    :param object ctx: Message processing context information wrapper.
    :param str simulation_state: New state of simulation being processed.

    """
    # Update state in db & cache simulation info.
    ctx.simulation = db.mq_hooks.update_simulation_status(
        ctx.simulation_uid, simulation_state)

    # Notify api.
    notify_api_of_simulation_state_change(ctx.simulation.id, simulation_state)


def notify_api_of_simulation_state_change(simulation_id, simulation_state):
    """Notifies web API of a simulation state change event.

    :param int simulation_id: ID of simulation being processed.
    :param str simulation_state: New state of simulation being processed.

    """
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_API,
            mode = mq.constants.MODE_TEST,
            timestamp = convert.now_to_timestamp())

    def _get_msg_body():
        """Returns message body."""
        return {
            u"event_type": "simulation_state_change",
            u"id": simulation_id,
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
            mode = mq.constants.MODE_TEST,
            timestamp = convert.now_to_timestamp())

    def _get_message():
        """Dispatch message source."""
        yield mq.Message(_get_msg_props(),
                         event_info,
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_get_message)


def _set_smtp_notification(operator_id, notification_type, simulation):
    """Adds an smtp notification to internal-smtp message queue."""
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST,
            timestamp = convert.now_to_timestamp())

    def _get_message_content():
        content = {
            'notificationType': notification_type,
            'operatorID': operator_id,
            'simulation': {
                'name': simulation.name,
                'uid': simulation.uid,
                'id': simulation.id
            }
        }

        return content

    def _get_message():
        """Dispatch message source."""
        yield mq.Message(_get_msg_props(),
                         _get_message_content(),
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_get_message)


def _set_sms_notification(operator_id, notification_type, simulation):
    """Adds an sms notification to internal-sms message queue."""
    def _get_msg_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.utils.create_ampq_message_properties(
            user_id = mq.constants.USER_PRODIGUER,
            producer_id = mq.constants.PRODUCER_PRODIGUER,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMS,
            mode = mq.constants.MODE_TEST,
            timestamp = convert.now_to_timestamp())

    def _get_message_content():
        content = {
            'notificationType': notification_type,
            'operatorID': operator_id,
            'simulation': {
                'name': simulation.name,
                'uid': simulation.uid,
                'id': simulation.id
            }
        }

        return content

    def _get_message():
        """Dispatch message source."""
        yield mq.Message(_get_msg_props(),
                         _get_message_content(),
                         mq.constants.EXCHANGE_PRODIGUER_INTERNAL)

    mq.produce(_get_message)


def notify_operator(ctx, notification_type):
    """Notifies operator of an event of interest.

    :param object ctx: Message processing context information wrapper.
    :param dict notification_info: Notification information.

    """
    operator_id = ctx.simulation.compute_node_login_id
    _set_smtp_notification(operator_id, notification_type, ctx.simulation)
    _set_sms_notification(operator_id, notification_type, ctx.simulation)
