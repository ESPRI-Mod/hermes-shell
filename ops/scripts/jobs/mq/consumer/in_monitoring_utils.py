from prodiguer import db, convert, mq



def update_simulation_state(simulation_name, simulation_state):
    """Updates state of a simulation.

    :param int simulation_name: Name of simulation being processed.
    :param str simulation_state: New state of simulation being processed.

    """
    # Update state in db.
    simulation = db.mq_hooks.update_simulation_status(
        simulation_name, simulation_state)

    # Notify api.
    notify_api_of_simulation_state_change(simulation.id, simulation_state)

    return simulation


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
