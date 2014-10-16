# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_realtime.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Realtime IMAP client that places email uid upon MQ server for futher processing.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import threading

from prodiguer import config, mail, mq, rt



class _State(object):
    """Module state bag.

    """
    def __init__(self):
        """Constructor.

        """
        # List of email uid's within AMPQ folder.
        self.email_stack = []

        # Message production throttling.
        self.throttle = 0
        self.produced = 0

        # Thread synchronization lock.
        self.lock = threading.Lock()


    def update_email_stack(self, new_stack):
        """Thread safe update of email uid stack.

        :param list new_stack: New stack of email uid's.

        """
        with self.lock:
            self.email_stack = new_stack


    def increment_produced(self):
        """Increments number of messages produced.

        """
        with self.lock:
            self.produced += 1


# Module state bag instance.
_STATE = _State()


def _invoke_async(target, args):
    """Helper function to invoke work upon a new thread."""
    thread = threading.Thread(target=target, args=args)
    thread.start()


def _get_message(uid):
    """Returns a message for dispatch to MQ server.

    """
    def _get_props():
        """Returns an AMPQ basic properties instance, i.e. message header."""
        return mq.create_ampq_message_properties(
            user_id = mq.constants.USER_IGCM,
            producer_id = mq.constants.PRODUCER_IGCM,
            app_id = mq.constants.APP_MONITORING,
            message_type = mq.constants.TYPE_GENERAL_SMTP,
            mode = mq.constants.MODE_TEST)

    def _get_body(uid):
        """Returns message body."""
        return {u"email_uid": uid}

    return mq.Message(_get_props(),
                      _get_body(uid),
                      mq.constants.EXCHANGE_PRODIGUER_EXT)


def _dispatch(uid_list):
    """Dispatches messages to MQ server.

    """
    def _get_messsages():
        """Dispatch message source."""
        for uid in uid_list:
            yield _get_message(uid)

    rt.log_mq("{0} new messages for dispatch: {1}".format(len(uid_list), uid_list))
    mq.produce(_get_messsages,
               connection_url=config.mq.connections.libigcm)


def _has_new_email_notification(idle_responses):
    """Returns flag indicating whether IMAP IDLE response contains new email notifications.

    """
    for idle_response in idle_responses:
        if len(idle_response) == 2 and idle_response[1] == u'EXISTS':
            return True
    return False


def _on_imap_idle_event(idle_responses):
    """IMAP IDLE event handler.

    """
    # Escape if no need to process event.
    if not _has_new_email_notification(idle_responses):
        return

    # Get mailbox mail uid stack.
    email_stack = mail.get_email_uid_list()

    # Caclulate mails requiring processing.
    diff = sorted(set(email_stack).difference(_STATE.email_stack))

    # Update stack.
    _STATE.update_email_stack(email_stack)

    # Dispatch mail uid's to MQ server for further processing.
    _dispatch(diff)


def _init_proxy():
    """IMAP server proxy initializer.

    """
    # Get imap server proxy.
    proxy = mail.get_imap_proxy()

    # Clear items marked for deletion.
    proxy.expunge()

    # Initialize email uid list.
    _STATE.email_stack = mail.get_email_uid_list(proxy)

    return proxy


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    """
    try:
        # Initialize state.
        _State.throttle = throttle

        # Initialize IMAP server proxy.
        proxy = _init_proxy()

        # Dispatch mail stack.
        _invoke_async(_dispatch, (_STATE.email_stack,))

        # Process imap notifications on new threads.
        proxy.idle()
        while True:
            _invoke_async(_on_imap_idle_event, (proxy.idle_check(),))

    # Simply log errors.
    except Exception as err:
        rt.log_mq_error(err)

    # Ensure imap proxy is closed.
    finally:
        mail.close_imap_proxy(proxy)
